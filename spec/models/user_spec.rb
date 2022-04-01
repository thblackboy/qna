require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:achieves).dependent(:nullify) }

  describe '#vote_to(item)' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:vote) { create(:vote, voter: user, votable: question) }
    it 'should return vote obj if it exist' do
      expect(user.vote_to(question)).to eq(vote)
    end

    it 'should return nil if vote does not exist' do
      expect(another_user.vote_to(question)).to be_nil
    end
  end

  describe '#author_of(item)' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:users_question) { create(:question, author: user) }
    it 'should return true if items.author_id equals users id' do
      expect(user.author_of?(users_question)).to be_truthy
    end

    it 'should return false if items.author_id does not equal users id' do
      expect(another_user.author_of?(users_question)).to be_falsey
    end
  end
end
