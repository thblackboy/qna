require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:another_question) { create(:question, author: another_user) }

  before { login(user) }

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    context 'with valid attributes' do
      it 'saves answer changes to db' do
        patch :update, params: { id: answer.id, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq('new body')
      end

      it 'render update view' do
        patch :update, params: { id: answer.id, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer changes to db' do
        expect do
          patch :update, params: { id: answer.id, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, author: another_user) }

      it 'does not save answer changes to db' do
        expect do
          patch :update, params: { id: another_answer.id, answer: { body: 'new body' } }, format: :js
        end.to_not change(another_answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: another_answer.id, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer to db' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, author: user), question_id: question }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer, author: user), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid, author: user), question_id: question },
                        format: :js
        end.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, author: user), question_id: question },
                      format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:another_answer) { create(:answer, question: another_question, author: user) }
    context 'is questions author' do
      it 'changes question best id' do
        patch :set_best, params: { id: answer.id }, format: :js
        question.reload
        expect(question.best_answer_id).to eq(answer.id)
      end
    end

    context 'is not questions author' do
      it 'doesnt change question best id' do
        patch :set_best, params: { id: another_answer.id }, format: :js
        question.reload
        expect(another_question.best_answer_id).to_not eq(another_answer.id)
      end
    end

    it 'render set_best view' do
      patch :set_best, params: { id: answer.id }, format: :js
      expect(response).to render_template :set_best
    end
  end

  describe 'DELETE #destroy' do
    context 'is author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes answer from db' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to change(question.answers, :count).by(-1)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: another_user) }

      it 'does not delete answer from db' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to_not change(question.answers, :count)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'is author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes answer from db' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to change(question.answers, :count).by(-1)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: another_user) }

      it 'does not delete answer from db' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to_not change(question.answers, :count)
      end

      it 'reditects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'DELETE #delete_attached_file' do
    context 'is author' do
      let!(:answer) { create(:answer, question: question, author: user) }
      before { answer.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
      it 'deletes attached file from db' do
        expect do
          delete :delete_attached_file, params: { id: answer, file_id: answer.files[0].id }, format: :js
          answer.reload
        end.to change(answer.files, :length).by(-1)
      end

      it 'render delete attached file' do
        delete :delete_attached_file, params: { id: answer, file_id: answer.files[0].id }, format: :js
        answer.reload
        expect(response).to render_template :delete_attached_file
      end
    end
    context 'is not author' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: another_user) }
      before { answer.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }

      it 'does not delete attached file from db' do
        expect do
          delete :delete_attached_file, params: { id: answer, file_id: answer.files[0].id }, format: :js
          answer.reload
        end.to_not change(answer.files, :length)
      end

      it 'render delete attached file' do
        delete :delete_attached_file, params: { id: answer, file_id: answer.files[0].id }, format: :js
        answer.reload
        expect(response).to render_template :delete_attached_file
      end
    end
  end
end
