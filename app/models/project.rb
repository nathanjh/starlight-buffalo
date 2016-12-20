class Project < ApplicationRecord
  belongs_to :user

  has_many :chapters
  has_many :images
end
