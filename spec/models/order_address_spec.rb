require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  before do
    # UserとItemをFactoryで作成
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)  # itemに関連付けるuserを設定
    # OrderAddressのインスタンスを作成
    @order_address = FactoryBot.build(:order_address, user_id: @user.id, item_id: @item.id)
  end

  describe '購入情報の保存' do
    context 'すべての値が正しく入力されていれば保存できる' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@order_address).to be_valid
      end

      it '建物名がなくても保存できる' do
        @order_address.building_name = ''
        expect(@order_address).to be_valid
      end
    end

    context '異常系でのテスト' do
      it 'tokenが空だと保存できない' do
        @order_address.token = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Token can't be blank")
      end

      it 'user_idが空だと保存できない' do
        @order_address.user_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空だと保存できない' do
        @order_address.item_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Item can't be blank")
      end

      it '電話番号が10桁以上11桁以内ではない場合無効' do
        @order_address.phone_number = '999999999' # 9桁
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Phone number is invalid. Input only number")
      end

      it '郵便番号がない場合無効' do
        @order_address.postal_code = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Postal code can't be blank")
      end

      it '郵便番号がハイフンなしの場合無効' do
        @order_address.postal_code = '1234567' # ハイフンなしの郵便番号
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Postal code is invalid. Include hyphen(-)")
      end

      it '都道府県が空の場合無効' do
        @order_address.prefecture_id = 0
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Prefecture must be other than 0")
      end

      it '市区町村がない場合無効' do
        @order_address.city = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("City can't be blank")
      end

      it '番地がない場合無効' do
        @order_address.address = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Address can't be blank")
      end

      it '電話番号がない場合無効' do
        @order_address.phone_number = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号が12桁以上の場合無効' do
        @order_address.phone_number = '999999999999' # 12桁
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Phone number is invalid. Input only number")
      end

      it '電話番号に英数字以外が含まれている場合無効' do
        @order_address.phone_number = '12345abcde' # 英数字以外を含む
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Phone number is invalid. Input only number")
      end
    end
  end
end
