class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic, optional: true
end
