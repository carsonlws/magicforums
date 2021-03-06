class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader

  validates :body, length: {minimum: 10}, presence: true
  belongs_to :user
  has_many :votes

  def total_votes
    votes.pluck(:value).sum
  end

end
