module RatingsHelper
  def get_category_score(class_name, concert_id)
    if rating = current_user.ratings.find_by(concert_id: concert_id)
      case class_name
      when 'people_score'
        rating.people_score
      when 'music_score'
        rating.music_score
      when 'venue_score'
        rating.venue_score
      when 'atmosphere_score'
        rating.atmosphere_score   
      end
    end
  end
end
