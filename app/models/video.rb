class Video < ActiveRecord::Base
  belongs_to :production

  validates :url, uniqueness: { message: 'already exists' }, format:
    { with: /((http|https):\/\/)?(www\.)?(youtube\.com)(\/)?([a-zA-Z0-9\-\.]+)\/?/, message: 'has an invalid format' }
    
  before_validation :truncate_url
  
  self.per_page = 2
  
  private # ====================================================================================================
  
  # This method is a `before_validation` callback.
  
  def truncate_url
    self.url.sub!(/((http|https):\/\/)?(www\.)?/, '') if self.url
  end
end