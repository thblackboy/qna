require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer to db' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, author: user), question_id: question }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer, author: user), question_id: question }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid, author: user), question_id: question }
        end.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, author: user), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'is author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes answer from db' do
        expect do
          delete :destroy, params: { question_id: question, id: answer }
        end.to change(question.answers, :count).by(-1)
      end

      it 'reditects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end
    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: another_user) }

      it 'does not delete answer from db' do
        expect do
          delete :destroy, params: { question_id: question, id: answer }
        end.to_not change(question.answers, :count)
      end

      it 'reditects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end
  end
end
