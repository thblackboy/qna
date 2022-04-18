require 'rails_helper'
describe 'Profile API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  describe 'GET /profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      it 'returns 200 status' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
  describe 'GET /profiles' do
    let(:api_path) { '/api/v1/profiles/' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 3) }
      it 'returns 200 status' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'returns list of users except me' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)
        expect(json.size).to eq 3
        json.each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it 'returns all public fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)
        %w[id email admin created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        json = JSON.parse(response.body)
        %w[password encrypted_password].each do |attr|
          expect(json.first).to_not have_key(attr)
        end
      end
    end
  end
end
