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
end
