require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  before { login(user) }

  describe 'DELETE #delete_attached_file' do
    context 'is author' do
      let!(:answer) { create(:answer, question: question, author: user) }
      before { answer.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
      it 'deletes attached file from db' do
        expect do
          delete :destroy, params: { id: answer.files[0].id }, format: :js
          answer.reload
        end.to change(answer.files, :length).by(-1)
      end

      it 'render delete attached file' do
        delete :destroy, params: { id: answer.files[0].id }, format: :js
        answer.reload
        expect(response).to render_template :destroy
      end
    end
    context 'is not author' do
      let!(:answer) { create(:answer, question: question, author: another_user) }
      before { answer.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }

      it 'does not delete attached file from db' do
        expect do
          delete :destroy, params: { id: answer.files[0].id }, format: :js
          answer.reload
        end.to_not change(answer.files, :length)
      end

      it 'render delete attached file' do
        delete :destroy, params: { id: answer.files[0].id }, format: :js
        answer.reload
        expect(response).to redirect_to root_url
      end
    end
  end
end
