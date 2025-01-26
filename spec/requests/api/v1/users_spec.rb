require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  let!(:users) { create_list(:user, 5) }
  let(:user_id) { users.first.id}

  describe 'GET /api/v1/index' do
    it 'returns all users' do
      get '/api/v1/index'

    # 返り値(render json: users)を変数に格納
    json = JSON.parse(response.body)
    # 200okが返ってきたか確認
    expect(response.status).to eq(200)
    # 10件のデータが返ってきているかを確認
    expect(json.length).to eq(5)
    end
  end

  describe 'GET /api/v1/:id/details' do
    it 'returns a user' do
      get "/api/v1/#{user_id}/details"

      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['id']).to eq(user_id)
    end
  end

  describe 'POST /api/v1/register' do
    let(:valid_attributes) { { name: 'Sample Taro', age: 20, email: 'taro4649@example.com' } }
    let(:invalid_attributes) { { name: '', age: nil, email: 'invalid-email' } }

    context 'request is valid' do
        it 'creates a new user' do
            # valid_attributesをリクエストデータでPOSTリクエストを送り、Userモデルのレコード数が1増加することを検証
            expect {
            post '/api/v1/register', params: valid_attributes
            }.to change(User, :count).by(1)
            # HTTPレスポンスステータスコードが201 Createdであることを確認
            expect(response.status).to eq(201)
        end
    end

    context 'request is invalid' do
        it 'creates a new user' do
            expect {
            post '/api/v1/register', params: invalid_attributes
            }.to_not change(User, :count)
            expect(response.status).to eq(422)
        end
    end
  end

  
end
