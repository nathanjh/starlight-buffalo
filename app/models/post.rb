class Post < ApplicationRecord
  belongs_to :project

  has_many :comments, as: :commentable
end
