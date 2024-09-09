# spec/controllers/orders_controller_spec.rb
require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item, user: user) }
  let(:non_owner) { FactoryBot.create(:user) }

  before do
    sign_in non_owner  # 他のユーザーでサインイン
  end

  describe 'GET #index' do
    context '購入ページへのアクセス' do
      it '購入ページに正常にアクセスできる' do
        get :index, params: { item_id: item.id }
        expect(response).to have_http_status(:success)
      end

      it '自分の商品にはアクセスできない' do
        sign_in user
        get :index, params: { item_id: item.id }
        expect(response).to redirect_to(root_path)
      end

      it '売却済みの商品にはアクセスできない' do
        FactoryBot.create(:order, item: item, user: non_owner)
        get :index, params: { item_id: item.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_order_params) do
      { item_id: item.id, order_address: { postal_code: '123-4567', prefecture_id: 2, city: 'Tokyo', address: 'Shibuya 1-1', building_name: 'Building', phone_number: '09012345678', token: 'tok_abcdefghijk00000000000000000' } }
    end

    let(:invalid_order_params) do
      { item_id: item.id, order_address: { postal_code: '', prefecture_id: 1, city: '', address: '', building_name: '', phone_number: '', token: '' } }
    end

    context '購入成功時' do
      it '注文が作成される' do
        post :create, params: valid_order_params
        expect(response).to redirect_to(root_path)
        expect(Order.count).to eq(1)
      end
    end

    context '購入失敗時' do
      it 'バリデーションエラー時は購入ページに戻る' do
        post :create, params: invalid_order_params
        expect(response).to render_template(:index)
      end

      it '支払い処理が失敗した場合、エラーメッセージが表示される' do
        allow_any_instance_of(Payjp::Charge).to receive(:create).and_raise(Payjp::InvalidRequestError.new("Payment failed."))
        post :create, params: valid_order_params
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Payment processing failed.")
      end
    end
  end
end
