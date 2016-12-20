class Post < ApplicationRecord
  belongs_to :project

  has_many :comments, as: :commentable

  validates_presence_of :title, :body
end
