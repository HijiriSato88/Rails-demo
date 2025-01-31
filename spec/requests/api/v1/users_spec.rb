require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  before { create_list(:user, 5) }
  let(:users) { User.all }
  let(:user) { users.first }
  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/v1/index' do
    let(:endpoint) { '/api/v1/index' }
    
    it 'returns all users' do
      get endpoint
      
      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(users.count)
    end
  end

  describe 'GET /api/v1/:id/details' do
    let(:endpoint) { "/api/v1/#{user.id}/details" }
    
    it 'returns a user' do
      get endpoint
      
      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(user.id)
    end
  end

  describe 'POST /api/v1/register' do
    let(:endpoint) { '/api/v1/register' }
    let(:valid_attributes) { { name: 'Sample Taro', age: 20, email: 'taro4649@example.com' } }
    let(:invalid_attributes) { { name: '', age: nil, email: 'invalid-email' } }

    context 'when request is valid' do
      it 'creates a new user' do
        expect {
          post endpoint, params: valid_attributes
        }.to change(User, :count).by(1)
        
        expect(response).to have_http_status(:created)
      end
    end

    context 'when request is invalid' do
      it 'does not create a new user' do
        expect {
          post endpoint, params: invalid_attributes
        }.not_to change(User, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/v1/:id/update' do
    let(:endpoint) { "/api/v1/#{user.id}/update" }
    let(:valid_attributes) { { name: 'Update Taro' } }
    let(:invalid_attributes) { { email: '' } }

    context 'when request is valid' do
      it 'updates the user' do
        patch endpoint, params: valid_attributes
        
        expect(response).to have_http_status(:ok)
        expect(json['data']['name']).to eq('Update Taro')
      end
    end

    context 'when request is invalid' do
      it 'does not update the user' do
        patch endpoint, params: invalid_attributes
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/:id/delete' do
    let(:endpoint) { "/api/v1/#{user.id}/delete" }
    
    it 'deletes the user' do
      expect {
        delete endpoint
      }.to change(User, :count).by(-1)
      
      expect(response).to have_http_status(:ok)
    end
  end
end
