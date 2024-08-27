# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @items = Item.order(created_at: :desc) # 最新順に商品を表示
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品が出品されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @itemはbefore_actionで設定済みのはず
  end

  def edit
    # 商品が購入済みであればトップページにリダイレクトするように設定した
    redirect_to root_path, alert: 'この商品はすでに購入済みです' if @item.order.present?
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: '商品情報が更新されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :condition_id, :shipping_id, :prefecture_id,
                                 :delivery_time_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def correct_user
    redirect_to root_path, alert: '不正なアクセスです' unless @item.user_id == current_user.id
  end
end
