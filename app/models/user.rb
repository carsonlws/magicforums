class User < ApplicationRecord
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  has_many :votes

  extend FriendlyId
  friendly_id :username, use: :slugged
  validates :username, uniqueness: true, presence: true

  validates :email, uniqueness: true, presence: true
  validate :email_regex

  def email_regex
    if email.present? and not email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      errors.add :email, "This is not a valid email format"
    end
  end

  enum role: [:user, :moderator, :admin]

  before_save :update_slug

  def update_slug
    if username
      self.slug = username.gsub(" ", "-")
    end
  end

end
