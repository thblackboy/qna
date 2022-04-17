require 'rails_helper'
describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let!(:question) { create(:question) }
  describe 'GET /questions/:question_id/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 3, question: question, author: me) }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        answers_json = json['answers']
        expect(answers_json.size).to eq 3
      end

      it 'returns all public fields' do
        answers_json = json['answers']
        first_answer = answers_json.first
        %w[id body author_id created_at updated_at].each do |attr|
          expect(first_answer[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /answers/:id ' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:link) { create(:link, linkable: answer) }
    let(:api_path) { api_v1_answer_path(answer) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context 'answer does not exist' do
        it 'returns 404 status' do
          get api_v1_answer_path(id: '1234'), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 404
        end
      end

      context 'answer exist' do
          before { get api_v1_answer_path(answer), params: { access_token: access_token.token }, headers: headers }
        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do 
          answer_json = json['answer']
          answer_comment = answer_json['comments'].first
          answer_link = answer_json['links'].first
          answer_file_url = answer_json['file_urls'].first
          %w[id body author_id question_id created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_comment[attr]).to eq comment.send(attr).as_json
          end
          %w[id name url created_at updated_at].each do |attr|
            expect(answer_link[attr]).to eq link.send(attr).as_json
          end
          expect(answer_file_url).to eq url_for(answer.files.first)
        end
      end
    end
  end

  describe 'POST /question/:id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { api_v1_question_answers_path(question) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "with valid params" do
        it 'returns 201 status and adds new answer to db' do
          post api_v1_question_answers_path(question), params: { answer: attributes_for(:answer), access_token: access_token.token }, headers: headers
          expect(response.status).to eq 201
        end
      end

      context "with invalid params" do
        it 'returns 403 status and does not add answer to db' do
          post api_v1_question_answers_path(question), params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }, headers: headers
          expect(response.status).to eq 400
        end
      end
    end
  end

  describe "DELETE /answers/:id" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:answer) { create(:answer, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "is author" do
        let!(:answer) { create(:answer, author: me) }
        it 'returns 200 status and deletes answer from db' do
          delete api_v1_answer_path(answer), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 200
        end
      end

      context "is not author" do
        let(:another_user) { create(:user) }
        let!(:answer) { create(:answer, author: another_user) }
        it 'returns 403 status and does not delete answer from db' do
          delete api_v1_answer_path(answer), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe "PATCH /answers/:id" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:answer) { create(:answer) }
    let(:api_path) { api_v1_answer_path(answer) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "is author" do
        let!(:answer) { create(:answer, author: me) }
        it 'returns 200 status and updates answer if params are valid' do
          patch api_v1_answer_path(answer), params: { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers
          expect(response.status).to eq 200
          answer.reload
          expect(answer.body).to eq('new body')
        end
        it 'returns 400 status and does not update question if params are not valid' do
          patch api_v1_answer_path(answer), params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
          expect(response.status).to eq 400
        end
      end

      context "is not author" do
        let(:another_user) { create(:user) }
        let!(:answer) { create(:answer, author: another_user) }
        it 'returns 403 status and does not delete question from db' do
          patch api_v1_answer_path(answer), params: { access_token: access_token.token, answer: { body: 'new body' } }, headers: headers
          expect(response.status).to eq 403
        end
      end
    end
  end
end