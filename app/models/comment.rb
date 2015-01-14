class Comment < ActiveRecord::Base
  belongs_to :production
  belongs_to :user
  has_many :notifications, dependent: :delete_all
  
  validates :content, presence: true
  
  self.per_page = 10
  
  def parse_symbols
    content_with_links = ''
    words = self.content.split
    words.each do |word|
      if word =~ /^@.+\b/ # Checks if the word is of the form "@username".
        username = word.tr('@,.?!', '')
        if referenced_user = extract_user_if_exists(username)
          notify_user_referenced(referenced_user)
          content_with_links << "<a href=/profiles/#{referenced_user.profile.id}>#{word}</a> "
        else
          content_with_links << word << ' '
        end
      elsif word =~ /^`Video_[0-9]+`/ # Checks if the word is of the form "`Video_(some number)`"
        video_number = word.tr('`,.?!', '')[6..-1]
        if video_exists?(video_number)
          content_with_links << "<a data-remote='true' 
            href=/productions/#{self.production_id}/videos/#{video_number}> #{word.delete('`')} </a> "
        else
          content_with_links << word
        end
      else
        content_with_links << word << ' '
      end
    end
    self.content = content_with_links
  end
  
  private # ====================================================================================================
  
  def extract_user_if_exists(username)
    if user = User.find_by(username: username)
      user
    else
      nil
    end
  end
  
  def video_exists?(id)
    if Video.find_by(id: id)
      true
    else
      false
    end
  end
  
  def notify_user_referenced(referenced_user)
    notification = self.notifications.build
    notification.profile_id = referenced_user.profile.id
    notification.referrer_username = User.find(self.user_id).username
    notification.save!
  end
end