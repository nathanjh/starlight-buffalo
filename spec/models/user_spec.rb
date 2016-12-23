require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(username: 'Anton.H', email: 'a@h.com', password: 'password') }
  let(:user2) { User.new(username: '', email: '', password: '') }
  let(:user3) { User.create!(username: 'Nathan.H', email: 'n@h.com', password: 'password') }
  let(:project) { Project.new(title: 'my project', description: 'a new test project!') }
  let(:post) { Post.new(title: 'my post', body: 'a test post!') }
  context 'when User instance is valid' do
    it 'is valid' do
      expect(user.save).to be true
    end

    it 'has a username' do
      expect(user.username).to eq 'Anton.H'
    end

    it 'has an email address' do
      expect(user.email).to eq 'a@h.com'
    end

    it 'has an encrypted password' do
      expect(user.password_digest).to be_a(String)
    end
  end

  context 'when User instance is invalid' do
    it 'is invalid' do
      expect(user2.save).to be false
    end
    it 'is invalid without a username' do
      user2.save
      expect(user2.errors.full_messages).to include("Username can't be blank")
    end

    it 'is invalid without an email' do
      user2.save
      expect(user2.errors.full_messages).to include("Email can't be blank")
    end

    it 'is invalid without a unique email' do
      dup_email = user3.email
      invalid_user = User.new(
        username: 'newDude',
        email: dup_email,
        password: 'password'
      )
      invalid_user.save
      expect(invalid_user.errors.full_messages).to include('Email has already been taken')
    end

    it 'is invalid unless a password exists' do
      user2.save
      expect(user2.errors.full_messages).to include("Password can't be blank")
    end
  end

  describe 'User associations' do
    it 'has projects' do
      expect(user.projects).to eq []

      user.projects << project

      expect(user.projects).to include project
    end

    # only the project owner can create posts.
    it 'has posts through projects' do
      user.projects << project
      user.projects.first.posts << post

      expect(user.posts).to include post
    end

    it 'has comments' do
      user.projects << project
      user.projects.first.posts << post
      u_id = user3.id
      post.comments.create!(body: 'great test post!', user_id: u_id)
      post.comments.create!(body: 'on second though...meh', user_id: u_id)

      expect(user3.comments.first.body).to eq 'great test post!'
      expect(user3.comments.length).to eq 2
    end
  end
end
