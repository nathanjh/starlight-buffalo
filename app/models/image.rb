class Image < ApplicationRecord
  belongs_to :chapter
  belongs_to :project
end
