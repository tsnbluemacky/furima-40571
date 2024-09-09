class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_item_owner, only: [:edit, :update, :destroy]
  before_action :prevent_sold_out_edit_or_delete, only: [:edit, :update, :destroy] # 売却済み商品の編集・削除制限

  def index
    @items = Item.order(created_at: :desc)
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品が作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: '商品情報が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: '商品を削除しました。'
    else
      redirect_to item_path(@item), alert: '商品の削除に失敗しました。再試行してください。'
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :condition_id, :shipping_fee_id, :prefecture_id,
                                 :delivery_time_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '指定された商品が見つかりません。'
  end

  # 所有者かどうかの確認
  def authorize_item_owner
    return if current_user == @item.user

    flash[:alert] = 'この操作は許可されていません。'
    redirect_to root_path
  end

  # 売却済み商品の編集・削除を防ぐ
  def prevent_sold_out_edit_or_delete
    if @item.order.present?
      flash[:alert] = '売却済み商品のため、編集や削除はできません。'
      redirect_to root_path
    end
  end
end
