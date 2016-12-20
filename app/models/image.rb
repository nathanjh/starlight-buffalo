class Image < ApplicationRecord
  belongs_to :chapter, optional: true
  belongs_to :project

  has_many :comments, as: :commentable

  validates_presence_of :title, :image_url
  validates_uniqueness_of :image_url
end
