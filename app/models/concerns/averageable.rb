module Averageable
  extend ActiveSupport::Concern
  
  def average_in_all_scores(averageable)
    if self.number_of_votes == 1
      self.people          = averageable.people
      self.music           = averageable.music
      self.venue           = averageable.venue
      self.atmosphere      = averageable.atmosphere
      self.aggregate_score = averageable.try(:aggregate_score) || 
        (self.people + self.music + self.venue + self.atmosphere) / 4
    else
      self.people          = (self.people * (self.number_of_votes - 1) + averageable.people) / self.number_of_votes
      self.music           = (self.music * (self.number_of_votes - 1) + averageable.music) / self.number_of_votes
      self.venue           = (self.venue * (self.number_of_votes - 1) + averageable.venue) / self.number_of_votes
      self.atmosphere      = 
        (self.atmosphere * (self.number_of_votes - 1) + averageable.atmosphere) / self.number_of_votes
      self.aggregate_score = (self.people + self.music + self.venue + self.atmosphere) / 4
    end
  end
  
  def average_in_category(old_category_score, updated_category_score, category_name)
    category_sans_updated_score = (self[category_name] * self.number_of_votes) - old_category_score
    self[category_name]         = (category_sans_updated_score + updated_category_score) / self.number_of_votes
    self.aggregate_score        = (self.people + self.music + self.venue + self.atmosphere) / 4
  end
  
  def remove_averageable_from_average(average, self_number_of_votes)
    if average.number_of_votes == self_number_of_votes
      average.people          = nil
      average.music           = nil
      average.venue           = nil
      average.atmosphere      = nil
      average.aggregate_score = nil
      average.number_of_votes = 0
      average.remove_rankable_from_rankings(average.class.ignore_null_ranks.best_rank.to_a)
      average.rank = nil
    else
      people     = average.people * average.number_of_votes
      music      = average.music * average.number_of_votes
      venue      = average.venue * average.number_of_votes
      atmosphere = average.atmosphere * average.number_of_votes
      average.number_of_votes -= self_number_of_votes
      average.people          = (people - self.people) / average.number_of_votes
      average.music           = (music - self.music) / average.number_of_votes
      average.venue           = (venue - self.venue) / average.number_of_votes
      average.atmosphere      = (atmosphere - self.atmosphere) / average.number_of_votes
      average.aggregate_score = (average.people + average.music + average.venue + average.atmosphere) / 4
      update_average_ranks(average)
    end
    average.save!
  end
  
  private # ====================================================================================================

  def update_average_ranks(average)
    self_aggregate_score = self.try(:aggregate_score) || (self.people + self.music + self.venue + self.atmosphere) / 4
    average_rankings    = average.class.ignore_null_ranks.best_rank.to_a
    direction            = average.aggregate_score > self_aggregate_score ? 'increased' : 'decreased'
    average.update_rankings(average_rankings, direction) unless
      average.aggregate_score == self_aggregate_score # Rare case that only occurs when deleting a rating.
  end
end
