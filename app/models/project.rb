class Project < ApplicationRecord
  belongs_to :user

  has_many :chapters
  has_many :images
  has_many :posts

  validates_presence_of :title
end
