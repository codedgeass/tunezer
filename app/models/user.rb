class User < ActiveRecord::Base 
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  has_one :profile, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  
  attr_accessor :login
  
  before_create :create_profile
  
  # Overwriting this devise method to allow login to be username or email.
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
  
  private # ====================================================================================================
  
  # This method is a `before_create` callback.
  
  def create_profile
    self.profile = self.build_profile
  end
end