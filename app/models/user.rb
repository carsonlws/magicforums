class User < ApplicationRecord
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  has_many :votes

  validates :email, uniqueness: true
  validate :email_regex

  def email_regex
    if email.present? and not email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      errors.add :email, "This is not a valid email format"
    end
  end

  enum role: [:user, :moderator, :admin]

end
