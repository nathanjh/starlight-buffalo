class Image < ApplicationRecord
  belongs_to :chapter, optional: true
  belongs_to :project

  has_many :comments, as: :commentable
end
