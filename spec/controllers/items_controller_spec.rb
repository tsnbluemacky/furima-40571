# spec/controllers/items_controller_spec.rb
require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:item) { create(:item, user:) }

  describe 'DELETE #destroy' do
    context 'ログインしていてアイテムの所有者の場合' do
      before { sign_in user }

      it 'アイテムが削除されること' do
        expect { delete :destroy, params: { id: item.id } }
          .to change(Item, :count).by(-1)
      end

      it '成功メッセージと共にルートパスにリダイレクトされること' do
        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq I18n.t('items.destroy.success')
      end
    end

    context 'ログインしているがアイテムの所有者でない場合' do
      let(:other_user) { create(:user) }
      before { sign_in other_user }

      it 'アイテムが削除されないこと' do
        expect { delete :destroy, params: { id: item.id } }
          .not_to change(Item, :count)
      end

      it '警告メッセージと共にルートパスにリダイレクトされること' do
        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq I18n.t('items.not_authorized')
      end
    end

    context 'ログインしていない場合' do
      it 'アイテムが削除されず、ログインページにリダイレクトされること' do
        expect { delete :destroy, params: { id: item.id } }
          .not_to change(Item, :count)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end
end
