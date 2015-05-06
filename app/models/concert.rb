class Concert < ActiveRecord::Base
  include Rankable, Averageable
  
  has_many :ratings, dependent: :delete_all
  has_many :videos, dependent: :delete_all
  has_many :comments, -> { order('created_at DESC') }, dependent: :destroy
  
  validates :name, :genre, presence: true
  validates :name, uniqueness: true

  scope :best_rank, -> { order('rank ASC') }
  scope :ignore_null_ranks, -> { where('rank IS NOT NULL') }
  
  before_destroy :remove_concert_from_concert_rankings
  
  self.per_page = 5
  
  private # ====================================================================================================
  
  # This method is a `before_destroy` callback.
  
  def remove_concert_from_concert_rankings
    remove_rankable_from_rankings(Concert.all.ignore_null_ranks.best_rank.to_a) unless self.rank.nil?
  end
end
