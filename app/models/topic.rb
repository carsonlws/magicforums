class Topic < ApplicationRecord
  has_many :posts

  validates :title, length: {minimum: 3}, presence: true
  validates :description, length: { minimum: 10 }, presence: true


end
