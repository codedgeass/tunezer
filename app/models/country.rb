class Country < ActiveRecord::Base
  has_many :comments, -> { order('created_at DESC') }, as: :commentable, dependent: :destroy
  has_many :concerts
end
