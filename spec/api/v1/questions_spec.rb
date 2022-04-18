require 'rails_helper'
describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  describe 'GET /questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 3) }
      it 'returns 200 status' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)['questions']
        expect(json.size).to eq 3
      end

      it 'returns all public fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)['questions']
        %w[id title body author_id best_answer_id created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq questions.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /questions/:id ' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context 'question does not exist' do
        it 'returns 404 status' do
          get api_v1_question_path(id: '1234'), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 404
        end
      end

      context 'question exist' do
        it 'returns 200 status' do
          get api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'returns all public fields' do 
          get api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers
          json = JSON.parse(response.body)['question']
          %w[id title body author_id created_at updated_at].each do |attr|
            expect(json[attr]).to eq question.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /questions' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { '/api/v1/questions/' }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "with valid params" do
        it 'returns 201 status and adds new question to db' do
          post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers
          expect(response.status).to eq 201
        end
      end

      context "with invalid params" do
        it 'returns 403 status and does not add question to db' do
          post '/api/v1/questions', params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
          expect(response.status).to eq 400
        end
      end
    end
  end

  describe "DELETE /questions/" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "is author" do
        let!(:question) { create(:question, author: me) }
        it 'returns 201 status and deletes question from db' do
          delete api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 200
        end
      end

      context "is not author" do
        let(:another_user) { create(:user) }
        let!(:question) { create(:question, author: another_user) }
        it 'returns 403 status and does not delete question from db' do
          delete api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe "PATCH /questions/" do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      context "is author" do
        let!(:question) { create(:question, author: me) }
        it 'returns 200 status and updates question if params are valid' do
          patch api_v1_question_path(question), params: { access_token: access_token.token, question: { title: 'new title' } }, headers: headers
          expect(response.status).to eq 200
          question.reload
          expect(question.title).to eq('new title')
        end
        it 'returns 400 status and does not update question if params are not valid' do
          patch api_v1_question_path(question), params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(response.status).to eq 400
          question.reload
          expect(question.title).to_not eq('new title')
        end
      end

      context "is not author" do
        let(:another_user) { create(:user) }
        let!(:question) { create(:question, author: another_user) }
        it 'returns 403 status and does not delete question from db' do
          patch api_v1_question_path(question), params: { access_token: access_token.token, question: { title: 'new title' } }, headers: headers
          expect(response.status).to eq 403
        end
      end
    end
  end
end