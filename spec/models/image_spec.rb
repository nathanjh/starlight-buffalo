require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'has a vaild factory' do
    expect(build(:image)).to be_valid
  end

  let(:image) { create(:image) }
  let(:image2) { build(:image, chapter: nil) }
  let(:title) { image.title }
  let(:url) { image.image_url }

  context 'when Image instance is valid' do
    it 'has a title' do
      expect(image.title).to eq title
    end

    it 'has a url' do
      expect(image.image_url).to eq url
    end

    it 'must have a unique url' do
      img = build(:image, image_url: url)
      img1 = build(:image)

      expect(img.save).to be false
      expect(img.errors.full_messages).to include 'Image url has already been taken'
      expect(img1.valid?).to be true
    end

    it 'can belong to a chapter or not' do
      chapter = Chapter.find(image.chapter_id)
      expect(chapter).not_to be_nil

      expect(image.chapter_id).to be_an(Integer)
      expect(image2.chapter_id).to be_nil
      expect(image2).to be_valid
    end
  end

  context 'when Image instance is invalid' do
    it 'is invalid' do
      img = Image.new
      expect(img).not_to be_valid
    end
    it 'is invalid without a title' do
      img = build(:image, title: nil)
      expect(img).not_to be_valid
      expect(img.errors.full_messages).to include "Title can't be blank"
    end

    it 'is invaild without a url' do
      img = build(:image, image_url: nil)
      expect(img).not_to be_valid
      expect(img.errors.full_messages).to include "Image url can't be blank"
    end

    it 'must belong to a project' do
      img = build(:image, project_id: nil)
      expect(img).not_to be_valid
      expect(img.errors.full_messages).to include 'Project must exist'
    end
  end

  describe 'associations' do
    it 'has comments' do
      new_comments = Array.new(4) { build(:comment) }
      new_comments.each { |comment| image.comments << comment }

      expect(image.comments.length).to eq new_comments.length
      expect(image.comments.first.body).to eq new_comments[-1].body
      expect(image.comments.last.user_id).to eq new_comments[0].user_id
    end

    it 'belongs to a project' do
      project = Project.find(image.project_id)
      expect(project).not_to be_nil
      expect(image.project_id).to be_an(Integer)
    end
  end
end
