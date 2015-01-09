module CommentsHelper
  def format_time(datetime)
    time_difference = (Time.now - datetime).to_i
    case time_difference
    when 0...2
      'Just Now'
    when 2...60
      "#{time_difference} seconds ago"
    when 60...3_600                                        # 3,600 seconds in an hour
      "#{pluralize time_difference/60, 'minute'} ago"
    when 3_600...86_400                                    # 86,400 seconds in a day
      "#{pluralize time_difference/3_600, 'hour'} ago"
    when 86_400...604_800                                  # 604,800 seconds in a week
      "#{pluralize time_difference/86_400, 'day'} ago"
    when 604_800...2_629_744                               # 2,629,744 seconds in a month
      "#{pluralize time_difference/604_800, 'week'} ago"
    when 2_629_744...31_556_926                            # 31,556,926 seconds in a year
      "#{pluralize time_difference/2_629_744, 'month'} ago"
    else
      "#{pluralize time_difference/31_556_926, 'year'} ago"
    end
  end
end
