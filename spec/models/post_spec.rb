require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a vaild factory' do
    expect(build(:post)).to be_valid
  end

  let(:post) { create(:post) }
  let(:title) { post.title }
  let(:body) { post.body }

  context 'when Post instance is valid' do
    it 'has a title' do
      expect(post.title).to eq title
    end

    it 'has a body' do
      expect(post.body).to eq body
    end
  end

  context 'when Post instance is invalid' do
    it 'is invalid' do
      post = Post.new
      expect(post).not_to be_valid
    end

    it 'is invalid without a title' do
      inv_post = build(:post, title: nil)
      expect(inv_post).not_to be_valid
      expect(inv_post.errors.full_messages).to include "Title can't be blank"
    end

    it 'is invaild without a body' do
      inv_post = build(:post, body: nil)
      expect(inv_post).not_to be_valid
      expect(inv_post.errors.full_messages).to include "Body can't be blank"
    end

    it 'is invalid without a project' do
      inv_post = build(:post, project: nil)
      expect(inv_post).not_to be_valid
      expect(inv_post.errors.full_messages).to include 'Project must exist'
    end
  end

  describe 'associations' do
    it 'has comments' do
      new_comments = Array.new(4) { build(:comment) }
      new_comments.each { |comment| post.comments << comment }

      expect(post.comments.length).to eq new_comments.length
      expect(post.comments.first.body).to eq new_comments[-1].body
      expect(post.comments.last.user_id).to eq new_comments[0].user_id
    end

    it 'belongs to a project' do
      project = Project.find(post.project_id)
      expect(project).not_to be_nil
      expect(post.project_id).to be_an(Integer)
    end
  end
end
