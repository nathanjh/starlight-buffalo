require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  let(:project1) { create(:project) }
  let(:title) { project1.title }
  let(:description) { project1.description }

  context 'when project instance is valid' do
    it 'has a title' do
      expect(project1.title).to eq title
    end

    it 'has a description' do
      expect(project1.description).to eq description
    end
  end

  context 'when project instance is invalid' do
    it 'is invalid' do
      inv_project = Project.new
      expect(inv_project.save).to be false
    end

    it 'is invalid without a title' do
      inv_project = build(:project, title: nil)
      inv_project.save
      expect(inv_project.errors.full_messages).to include "Title can't be blank"
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      user = User.find(project1.user_id)
      expect(user).not_to be_nil
      expect(project1.user_id).to be_an(Integer)
    end

    it 'has chapters' do
      project1.chapters.create(title: 'Chapter One')
      expect(project1.chapters.first.title).to eq 'Chapter One'
    end

    it 'has images' do
      img = build(:image, chapter: nil)
      project1.images << img
      expect(project1.images).to include img
    end

    it 'has posts' do
      post = build(:post)
      project1.posts << post
      expect(project1.posts).to include post
    end
  end
end
