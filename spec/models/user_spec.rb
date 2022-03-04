require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:achieves).dependent(:nullify) }


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
