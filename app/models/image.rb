class Image < ApplicationRecord
  belongs_to :chapter
  belongs_to :project

  has_many :comments, as: :commentable
end
