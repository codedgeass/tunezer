class Rating < ActiveRecord::Base
  include Averageable
  
  belongs_to :concert
  belongs_to :user
  
  before_destroy :remove_rating_from_concert_score
  
  def increased_or_decreased(category_name, old_score)
    if old_score.nil? || self[category_name] > old_score
      'increased'
    elsif self[category_name] < old_score
      'decreased'
    end
  end
  
  def complete?
    if self.people_score && self.music_score && self.venue_score && self.atmosphere_score
      true
    else
      false
    end
  end
  
  def just_completed?(old_score)
    if old_score.nil?
      true
    else
      false
    end
  end
  
  private # ====================================================================================================
  
  # This method is a `before_destroy` callback.
  
  def remove_rating_from_concert_score
    remove_averageable_from_average(Concert.find(self.concert_id), 1)
  end
end