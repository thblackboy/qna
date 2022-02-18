require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }
  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves new question to db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new question to db' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'is author' do
      let!(:question) { create(:question, author: user) }

      it 'deletes question from db' do
        expect do
          delete :destroy, params: { id: question }
        end.to change(Question, :count).by(-1)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:question) { create(:question, author: another_user) }

      it 'does not delete question from db' do
        expect do
          delete :destroy, params: { id: question }
        end.to_not change(Question, :count)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
