require 'rails_helper'

RSpec.describe Chapter, type: :model do
  it 'has a valid factory' do
    expect(build(:chapter)).to be_valid
  end

  let(:chapter1) { create(:chapter) }
  let(:title) { chapter1.title }

  context 'when chapter instance is valid' do
    it 'has a title' do
      expect(chapter1.title).to eq title
    end
  end

  context 'when chapter instance is invalid' do
    it 'is invalid' do
      inv_chapter = Chapter.new
      expect(inv_chapter.valid?).to be false
    end

    it 'is invalid without a title' do
      inv_chapter = build(:chapter, title: nil)
      inv_chapter.save
      expect(inv_chapter.errors.full_messages).to include "Title can't be blank"
    end
  end

  describe 'associations' do
    it 'has images' do
      images = Array.new(3) { build(:image) }
      images.each { |img| chapter1.images << img }

      expect(chapter1.images.first.image_url).to eq images[0].image_url
      expect(chapter1.images.length).to eq images.length
    end

    it 'belongs to a project' do
      project = Project.find(chapter1.project_id)
      expect(project).not_to be_nil
      expect(chapter1.project_id).to be_an(Integer)
    end
  end
end
