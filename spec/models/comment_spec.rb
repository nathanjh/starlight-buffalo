require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'has a vaild factory' do
    expect(build(:post_comment)).to be_valid
    expect(build(:image_comment)).to be_valid
  end

  let(:img_comment) { create(:image_comment) }
  let(:body) { img_comment.body }
  let(:pst_comment) { create(:post_comment) }

  describe 'validations' do
    it 'is must have a body' do
      comment = build(:image_comment, body: nil)
      expect(comment).not_to be_valid
      expect(comment.errors.full_messages).to include "Body can't be blank"
      expect(img_comment).to be_valid
      expect(img_comment.body).to eq body
    end
  end

  describe 'associations' do
    it 'must belong to commentable' do
      inv_comment = build(:post_comment, commentable: nil)
      expect(inv_comment).not_to be_valid
      expect(inv_comment.errors.full_messages).to include 'Commentable must exist'
    end

    it 'is polymorphic with Post model' do
      expect(pst_comment.commentable_type).to eq 'Post'
      expect(pst_comment.commentable_id).to be_an(Integer)

      post = Post.find(pst_comment.commentable_id)
      expect(post).not_to be_nil
    end

    it 'is polymorphic with Image model' do
      expect(img_comment.commentable_type).to eq 'Image'
      expect(img_comment.commentable_id).to be_an(Integer)

      image = Image.find(img_comment.commentable_id)
      expect(image).not_to be_nil
    end
  end
end
