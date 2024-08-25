require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザ登録ができる時' do
    it '全ての属性が正しく設定されている場合、有効であること' do
      expect(@user).to be_valid
    end
  end

  context 'ユーザ登録ができない時' do
    it 'ニックネームがない場合、無効であること' do
      @user.nickname = nil
      @user.valid?
      expect(@user.errors[:nickname]).to include("can't be blank")
    end

    it '重複したメールアドレスがある場合、無効であること' do
      duplicate_user = @user.dup
      @user.save
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end

    it '短すぎるパスワードの場合、無効であること' do
      @user.password = @user.password_confirmation = 'short'
      @user.valid?
      expect(@user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it '数字だけのパスワードの場合、無効であること' do
      @user.password = @user.password_confirmation = '123456'
      @user.valid?
      expect(@user.errors[:password]).to include('must include both letters and numbers')
    end

    it '英字だけのパスワードの場合、無効であること' do
      @user.password = @user.password_confirmation = 'abcdef'
      @user.valid?
      expect(@user.errors[:password]).to include('must include both letters and numbers')
    end

    it 'メールアドレスが不正な形式の場合、無効であること' do
      @user.email = 'invalid_email'
      @user.valid?
      expect(@user.errors[:email]).to include('is invalid')
    end

    it '誕生日がない場合、無効であること' do
      @user.birth_date = nil
      @user.valid?
      expect(@user.errors[:birth_date]).to include("can't be blank")
    end

    it '姓が全角でない場合、無効であること' do
      @user.last_name = 'Yamada'
      @user.valid?
      expect(@user.errors[:last_name]).to include('is invalid. Input full-width characters')
    end

    it '名が全角でない場合、無効であること' do
      @user.first_name = 'Taro'
      @user.valid?
      expect(@user.errors[:first_name]).to include('is invalid. Input full-width characters')
    end

    it '姓のカナが全角カタカナでない場合、無効であること' do
      @user.last_name_kana = 'やまだ'
      @user.valid?
      expect(@user.errors[:last_name_kana]).to include('is invalid. Input full-width katakana characters')
    end

    it '名のカナが全角カタカナでない場合、無効であること' do
      @user.first_name_kana = 'たろう'
      @user.valid?
      expect(@user.errors[:first_name_kana]).to include('is invalid. Input full-width katakana characters')
    end

    it 'パスワードとパスワード確認用が一致しない場合、無効であること' do
      @user.password = 'password123'
      @user.password_confirmation = 'differentpassword'
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'メールアドレスに@が含まれていない場合、無効であること' do
      @user.email = 'invalidemail.com'
      @user.valid?
      expect(@user.errors[:email]).to include('is invalid')
    end

    it 'パスワードが空の場合、無効であること' do
      @user.password = ''
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it 'パスワード確認用が空の場合、無効であること' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("can't be blank")
    end
  end
end
