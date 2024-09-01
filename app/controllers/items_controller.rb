class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  # before_action :set_item, only: [:show, :edit, :update, :destroy]
  # before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] # destroyを追加
  before_action :set_item, only: [:show, :edit, :update, :destroy] # destroyを追加
  before_action :correct_user, only: [:edit, :update, :destroy] # destroyを追加

  def index
    @items = Item.order(created_at: :desc) # 商品を新しい順に取得
  end
  # その他のアクションはそのまま
  # 商品一覧機能を有効にする
  # @items = Item.order(created_at: :desc)
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save

      redirect_to root_path, notice: '商品が出品されました'
    else
      logger.debug "Item creation failed: #{@item.errors.full_messages.join(', ')}"

      redirect_to root_path
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @itemはbefore_actionで設定済み
  end

  def edit
    # 商品が購入済みであればトップページにリダイレクト
    # return unless @item.order.present?

    # redirect_to root_path, alert: 'この商品はすでに購入済みです'
  end

  def update
    # if @item.update(item_params)
    #   redirect_to item_path(@item), notice: '商品情報が更新されました'
    # else
    #   logger.debug "Item update failed: #{@item.errors.full_messages.join(', ')}"
    #   render :edit, status: :unprocessable_entity
    # end
  end

  def destroy
    # @item.destroy
    # redirect_to root_path, notice: '商品が削除されました'
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.user_id == current_user.id
      @item.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :condition_id, :shipping_id, :prefecture_id,
                                 :delivery_time_id, :price).merge(user_id: current_user.id)
  end

  # def set_item
  #   @item = Item.find(params[:id])
  # end

  # def correct_user
  #   return if @item.user_id == current_user.id

  #   redirect_to root_path, alert: '不正なアクセスです'
  # end

  def set_item
    @item = Item.find(params[:id])
  end

  def correct_user
    return if current_user == @item.user

    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to root_path
  end

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :condition_id, :shipping_fee_id, :prefecture_id,
                                 :shipping_day_id, :price, :image).merge(user_id: current_user.id)
  end
end
