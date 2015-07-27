module Averageable
  extend ActiveSupport::Concern
  
  def average_in_all_scores(averageable)
    if self.votes == 1
      self.people_score          = averageable.people_score
      self.music_score           = averageable.music_score
      self.venue_score           = averageable.venue_score
      self.atmosphere_score      = averageable.atmosphere_score
      self.aggregate_score = averageable.try(:aggregate_score) || 
        (self.people_score + self.music_score + self.venue_score + self.atmosphere_score) / 4
    else
      self.people_score          = (self.people_score * (self.votes - 1) + averageable.people_score) / 
                                      self.votes
      self.music_score           = (self.music_score * (self.votes - 1) + averageable.music_score) / 
                                      self.votes
      self.venue_score           = (self.venue_score * (self.votes - 1) + averageable.venue_score) / 
                                      self.votes
      self.atmosphere_score      = (self.atmosphere_score * (self.votes - 1) + 
                                      averageable.atmosphere_score) / self.votes
      self.aggregate_score = (self.people_score + self.music_score + self.venue_score + self.atmosphere_score) / 4
    end
  end
  
  def average_in_category(old_category_score, updated_category_score, category_name)
    category_sans_updated_score = (self[category_name] * self.votes) - old_category_score
    self[category_name]         = (category_sans_updated_score + updated_category_score) / self.votes
    self.aggregate_score        = (self.people_score + self.music_score + self.venue_score + self.atmosphere_score) / 4
  end
  
  def remove_averageable_from_average(average, self_votes)
    if average.votes == self_votes
      average.people_score          = nil
      average.music_score           = nil
      average.venue_score           = nil
      average.atmosphere_score      = nil
      average.aggregate_score = nil
      average.votes = 0
      average.remove_rankable_from_rankings(average.class.ignore_null_ranks.best_rank.to_a)
      average.rank = nil
    else
      people_score     = average.people_score * average.votes
      music_score      = average.music_score * average.votes
      venue_score      = average.venue_score * average.votes
      atmosphere_score = average.atmosphere_score * average.votes
      average.votes -= self_votes
      average.people_score          = (people_score - self.people_score) / average.votes
      average.music_score           = (music_score - self.music_score) / average.votes
      average.venue_score           = (venue_score - self.venue_score) / average.votes
      average.atmosphere_score      = (atmosphere_score - self.atmosphere_score) / average.votes
      average.aggregate_score = (average.people_score + average.music_score + average.venue_score +
                                  average.atmosphere_score) / 4
      update_average_ranks(average)
    end
    average.save!
  end
  
  private # ====================================================================================================

  def update_average_ranks(average)
    self_aggregate_score = self.try(:aggregate_score) || (self.people_score + self.music_score + self.venue_score + self.atmosphere_score) / 4
    average_rankings     = average.class.ignore_null_ranks.best_rank.to_a
    direction            = average.aggregate_score > self_aggregate_score ? 'increased' : 'decreased'
    average.update_rankings(average_rankings, direction) unless
      average.aggregate_score == self_aggregate_score # Rare case that only occurs when deleting a rating.
  end
end
