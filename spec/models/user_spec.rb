require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { build(:user) }

    it 'is valid with valid attributes' do
        expect(user).to be_valid
    end

    it 'is invalid without a name' do
        user.name = nil
        expect(user).to_not be_valid
    end

    it 'is invalid with a name shorter than 2 characters' do
        user.name = 'A'
        expect(user).to_not be_valid
    end

    it 'is invalid with a name longer than 50 characters' do
        user.name = Faker::Lorem.characters(number: 51) 
        expect(user).to_not be_valid
    end

    it 'is invalid without an age' do
        user.age = nil
        expect(user).to_not be_valid
    end

    it 'is invalid with an age less than 0' do
        user.age = -1
        expect(user).to_not be_valid
    end

    it 'is invalid without an email' do
        user.email = nil
        expect(user).to_not be_valid
    end

    it 'is invalid with an improperly formatted email' do
        user.email = 'invalid_email'
        expect(user).to_not be_valid
    end

    it 'is invalid with a duplicate email' do
        create(:user, email: user.email)
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('has already been taken')
    end
end
