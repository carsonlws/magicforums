class Topic < ApplicationRecord
  has_many :posts
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, length: {minimum: 3}, presence: true
  validates :description, length: { minimum: 10 }, presence: true

end
