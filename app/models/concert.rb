class Concert < ActiveRecord::Base
  include Rankable, Averageable
  
  has_many :ratings, dependent: :delete_all
  belongs_to :production
  
  validates :name, presence: true, uniqueness: { scope: :production_id }

  scope :best_rank, -> { order('rank ASC') }
  scope :ignore_null_ranks, -> { where('rank IS NOT NULL') }
  
  # TODO: Don't need to run either method if parent production is being destroyed as well.
  before_destroy :remove_concert_from_concert_rankings, :remove_concert_from_production_score
  
  self.per_page = 5
  
  private # ====================================================================================================
  
  # These methods are `before_destroy` callbacks.
  
  def remove_concert_from_concert_rankings
    remove_rankable_from_rankings(Production.find(self.production_id).concerts.ignore_null_ranks.best_rank.to_a) unless
      self.rank.nil?
  end
  
  def remove_concert_from_production_score
    remove_averageable_from_average(Production.find(self.production_id), self.number_of_votes) unless
      self.aggregate_score.nil?
  end
end
