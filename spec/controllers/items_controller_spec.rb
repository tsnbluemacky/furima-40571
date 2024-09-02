require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:item) { create(:item, user:) }

  describe 'DELETE #destroy' do
    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'deletes the item' do
        expect do
          delete :destroy, params: { id: item.id }
        end.to change(Item, :count).by(-1)
      end

      it 'redirects to the root path' do
        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the user is not the owner of the item' do
      let!(:other_user) { create(:user) }
      before do
        sign_in other_user
      end

      it 'does not delete the item' do
        expect do
          delete :destroy, params: { id: item.id }
        end.to_not change(Item, :count)
      end

      it 'redirects to the root path with an alert' do
        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq '許可されていない操作です'
      end
    end

    context 'when the user is not logged in' do
      it 'does not delete the item and redirects to the login page' do
        expect do
          delete :destroy, params: { id: item.id }
        end.to_not change(Item, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
