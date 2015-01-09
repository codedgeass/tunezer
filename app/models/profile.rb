class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :notifications, -> { order('created_at DESC') }, dependent: :delete_all
  
  validates :real_name, :hometown, 
    format: { with: /\A[a-zA-Z\s]+\z/, message: 'only allows English letters' }, allow_blank: true
  validates :age, numericality: { only_integer: true }, allow_blank: true
  validate :any_present?, on: :update
  
  private # ====================================================================================================
  
  def any_present?
    if %w(real_name age hometown favorite_artists favorite_songs).all?{ |attr| self[attr].blank? }
      errors.add :base, %q(Don't leave them all blank!)
    end
  end
end