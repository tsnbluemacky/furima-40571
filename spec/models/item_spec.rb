require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item, user: @user)
  end

  describe '商品出品機能' do
    context '商品を出品できる時' do
      it 'nameとtextとcategory_idとcondition_idとshipping_idとprefecture_idとdelivery_time_idとpriceと画像があれば登録できる' do
        expect(@item).to be_valid
      end
    end

    context '商品を出品できないとき' do
      it '商品画像がないと出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include "Image can't be blank"
      end

      it '商品名がないと出品できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Name can't be blank"
      end

      it '商品説明がないと出品できない' do
        @item.text = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Text can't be blank"
      end

      it 'カテゴリーが選択されていないと出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include 'Category を選択してください'
      end

      it '商品の状態が選択されていないと出品できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include 'Condition を選択してください'
      end

      it '配送料の負担が選択されていないと出品できない' do
        @item.shipping_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include 'Shipping を選択してください'
      end

      it '発送元の地域が選択されていないと出品できない' do
        @item.prefecture_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include 'Prefecture を選択してください'
      end

      it '発送までの日数が選択されていないと出品できない' do
        @item.delivery_time_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include 'Delivery time を選択してください'
      end

      it '販売価格がないと出品できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Price can't be blank"
      end

      it '販売価格が299円以下では出品できない' do
        @item.price = 200
        @item.valid?
        expect(@item.errors.full_messages).to include 'Price 販売可能価格外です'
      end

      it '販売価格が9,999,999円以上では出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include 'Price 販売可能価格外です'
      end

      it '半角数字以外の値が含まれている場合は出品できない' do
        @item.price = 'abcd'
        @item.valid?
        expect(@item.errors.full_messages).to include 'Price 販売可能価格外です'
      end

      it 'userが紐付いていないと保存できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end
    end
  end
end
