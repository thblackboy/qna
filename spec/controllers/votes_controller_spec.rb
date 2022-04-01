require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before { login(user) }
  describe 'DELETE #destroy' do
    let(:question) { create(:question, author: another_user) }
    context 'is voter' do
      let!(:vote) { create(:vote, voter: user, votable: question) }

      it 'deletes vote from db' do
        expect do
          delete :destroy, params: { id: vote }
        end.to change(Vote, :count).by(-1)
      end
    end
    context 'is not voter' do
      let!(:vote) { create(:vote, voter: another_user, votable: question) }

      it 'does not delete vote from db' do
        expect do
          delete :destroy, params: { id: vote }
        end.to_not change(Question, :count)
      end
    end
  end
end
