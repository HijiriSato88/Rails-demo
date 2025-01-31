require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  let!(:users) { create_list(:user, 5) } # テスト実行前。テストが開始する前に変数の値が設定される
  let(:user_id) { users.first.id} # テスト実行中、その変数が最初に参照されたときに評価

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

  describe 'PATCH /api/v1/:id/update' do
    let(:valid_attributes) { {name: "Update Taro"} }
    let(:invalid_attributes) { {email: ""} }
    
    context 'is valid' do
      it 'update the user' do
        patch "/api/v1/#{user_id}/update", params: valid_attributes
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['name']).to eq("Update Taro")
      end
    end

    context 'when the request is invalid' do
      it 'does not update the user' do
        patch "/api/v1/#{user_id}/update", params: invalid_attributes
        json = JSON.parse(response.body)

        expect(response.status).to eq(422) 
        expect(json['data']).to have_key('email')
      end
    end
  end

  describe 'DELETE api/v1/:id/delete' do
    context 'success' do
      it 'deletes the user' do
        expect {
          delete "/api/v1/#{user_id}/delete"
        }.to change(User, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end
  end
end
