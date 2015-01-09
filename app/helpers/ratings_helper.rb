module RatingsHelper
  def get_category_score(class_name, concert_id)
    if rating = current_user.ratings.find_by(concert_id: concert_id)
      case class_name
      when 'people'
        rating.people
      when 'music'
        rating.music
      when 'venue'
        rating.venue
      when 'atmosphere'
        rating.atmosphere       
      end
    end
  end
end
