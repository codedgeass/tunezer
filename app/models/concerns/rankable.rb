module Rankable
  extend ActiveSupport::Concern
  
  def update_rankings(rankables, direction) # O(n)
    if rankables.size == 0
      self.rank = 1
    else
      initial_position = rankables.index(self) || rankables.size
      if direction == 'increased'
        demote_equivalent_ranks_below_self(rankables[(initial_position + 1)..-1]) unless 
          initial_position >= rankables.size - 1
        if initial_position != 0
          ranks_greater_than_self = demote_and_drop_equivalent_ranks_above_self(rankables[0..(initial_position - 1)])
          reposition_rankable_with_higher_ranks(ranks_greater_than_self) unless ranks_greater_than_self == 0
        end
      elsif direction == 'decreased'
        if initial_position == rankables.size - 1
          self.rank = rankables.size        # The score was decreased so the rank will fall behind any previous ties.
        else
          ranks_less_than_self = drop_equivalent_ranks_below_self(rankables[(initial_position + 1)..-1])
          reposition_rankable_within_lower_ranks(ranks_less_than_self, rankables.size) unless 
            ranks_less_than_self == 0
        end
      else
        raise ArgumentError, 'The direction is neither "increased" or "decreased".'
      end
    end
  end
  
  def remove_rankable_from_rankings(rankables)
    start_position = rankables.index(self) + 1
    return if rankables.size == start_position
    rankables[start_position..-1].each do |rankable|
      if self.rank < rankable.rank
        rankable.rank -= 1
        rankable.save!
      end
    end
  end
  
  private # ====================================================================================================
  
  # These methods are used in `update_rankings` when a score is increased.
  
  def demote_equivalent_ranks_below_self(rankables_below_self)
    rankables_below_self.each do |rankable|
      if self.rank == rankable.rank
        rankable.rank += 1
        rankable.save!
      else
        return
      end
    end
  end
  
  def demote_and_drop_equivalent_ranks_above_self(rankables_above_self)
    current_position = rankables_above_self.size - 1
    rankables_above_self.reverse_each do |rankable|
      if self.rank == rankable.rank
        rankable.rank += 1
        rankable.save!
        current_position -= 1
      else
        return rankables_above_self[0..current_position]
      end
    end
    return 0
  end
  
  def reposition_rankable_with_higher_ranks(rankables_greater_than_self)
    rankables_greater_than_self.reverse_each.with_index do |rankable, index|
      if self.aggregate_score > rankable.aggregate_score
        rankable.rank += 1
        rankable.save!
      elsif self.aggregate_score == rankable.aggregate_score
        self.rank = rankable.rank
        return
      else # self.aggregate_score < rankable.aggregate_score
        self.rank = rankables_greater_than_self.size + 1 - index
        return
      end
    end
    self.rank = 1
  end
  
  # These methods are used in `update_rankings` when a score is decreased.
  
  def drop_equivalent_ranks_below_self(rankables_below_self)
    rankables_below_self.each_with_index do |rankable, index|
      return rankables_below_self[index..-1] if self.rank != rankable.rank
    end
    return 0
  end
  
  def reposition_rankable_within_lower_ranks(rankables_less_than_self, initial_size)
    rankables_less_than_self.each_with_index do |rankable, index|
      if self.aggregate_score < rankable.aggregate_score
        rankable.rank -= 1
        rankable.save!
      elsif self.aggregate_score == rankable.aggregate_score
        rankable.rank -= 1
        rankable.save!
        next_rankable = rankables_less_than_self[index + 1]
        if next_rankable.nil? || self.aggregate_score > next_rankable.aggregate_score
          self.rank = rankable.rank
          return
        end
      else # self.aggregate_score > rankable.aggregate_score
        self.rank = rankable.rank - 1
        return
      end
    end
    self.rank = initial_size
  end
end