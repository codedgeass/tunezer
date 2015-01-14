class Production < ActiveRecord::Base
  include Rankable, Averageable
  
  has_many :videos, dependent: :delete_all
  has_many :comments, -> { order('created_at DESC') }, dependent: :destroy
  has_many :concerts, dependent: :destroy
  
  validates :name, :genre, :category, presence: true
  validates :name, uniqueness: true

  scope :best_rank, -> { order('rank ASC') }
  scope :ignore_null_ranks, -> { where('rank IS NOT NULL') }
  
  before_destroy :remove_production_from_production_rankings
  
  self.per_page = 10
  
  private # ====================================================================================================
  
  # This method is a `before_destroy` callback.
  
  def remove_production_from_production_rankings
    remove_rankable_from_rankings(Production.ignore_null_ranks.best_rank.to_a) unless 
      self.reload.rank.nil? # Reload `self` since callbacks run when destroying concerts could nullify its rank.
  end
end