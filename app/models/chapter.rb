class Chapter < ApplicationRecord
  belongs_to :project

  has_many :images

  validates_presence_of :title
end
