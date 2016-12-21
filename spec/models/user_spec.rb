require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { User.new(username: 'Anton.H', email: 'a@h.com', password: 'password') }

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

  # context 'when User instance is invalid' do
  #   let(:user2) { User.new(username: '', email: '', password: '') }
  #   user2.save
  #
  #   it 'must have a username' do
  #
  #   end
  # end
end
