class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader

  validates :title, length: {minimum: 3}, presence: true
  validates :body, length: { minimum: 10 }, presence: true
  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: :slugged
end
