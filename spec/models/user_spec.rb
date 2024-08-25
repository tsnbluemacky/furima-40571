require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        nickname: 'TestUser',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        first_name: '太郎',
        last_name: '山田',
        first_name_kana: 'タロウ',
        last_name_kana: 'ヤマダ',
        birth_date: '2000-01-01'
      )
      expect(user).to be_valid
    end

    it 'is invalid without a nickname' do
      user = User.new(nickname: nil)
      user.valid?
      expect(user.errors[:nickname]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create(
        nickname: 'ExistingUser',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        first_name: '太郎',
        last_name: '山田',
        first_name_kana: 'タロウ',
        last_name_kana: 'ヤマダ',
        birth_date: '2000-01-01'
      )
      user = User.new(
        nickname: 'AnotherUser',
        email: 'test@example.com',
        password: 'password456',
        password_confirmation: 'password456',
        first_name: '次郎',
        last_name: '鈴木',
        first_name_kana: 'ジロウ',
        last_name_kana: 'スズキ',
        birth_date: '2000-02-02'
      )
      user.valid?
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with a short password' do
      user = User.new(password: 'short', password_confirmation: 'short')
      user.valid?
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it 'is invalid with a password containing only numbers' do
      user = User.new(password: '123456', password_confirmation: '123456')
      user.valid?
      expect(user.errors[:password]).to include('must include both letters and numbers')
    end

    it 'is invalid with a password containing only letters' do
      user = User.new(password: 'abcdef', password_confirmation: 'abcdef')
      user.valid?
      expect(user.errors[:password]).to include('must include both letters and numbers')
    end
  end
end
