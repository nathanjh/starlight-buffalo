class User < ApplicationRecord
  has_secure_password

  has_many :projects
  has_many :comments
  # only the project owner can create posts
  has_many :posts, through: :projects

  validates_presence_of :username, :email, :password
  validates_uniqueness_of :username, :email

  validates :password, confirmation: true
end
