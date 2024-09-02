class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_item_owner, only: [:edit, :update, :destroy]

  def index
    @items = Item.order(created_at: :desc)
    Rails.logger.info("Item index accessed by #{current_user&.email || 'Guest'}")
  end

  def show
    Rails.logger.info("Item #{@item.id} viewed by #{current_user&.email || 'Guest'}")
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      Rails.logger.info("Item #{@item.id} created by #{current_user.email}")
      redirect_to @item, notice: '商品が作成されました。'
    else
      Rails.logger.error("Item creation failed: #{@item.errors.full_messages.join(', ')}")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      Rails.logger.info("Item #{@item.id} destroyed by #{current_user.email}")
      redirect_to root_path, notice: '商品を削除しました。'
    else
      Rails.logger.error("Item deletion failed: #{@item.errors.full_messages.join(', ')}")
      redirect_to edit_item_path(@item), alert: '商品の削除に失敗しました。再試行してください。'
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :condition_id, :shipping_fee_id, :prefecture_id,
                                 :delivery_time_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
    Rails.logger.info("Item #{@item.id} set for processing")
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("Item with id #{params[:id]} not found")
    redirect_to root_path, alert: '指定された商品が見つかりません。'
  end

  def authorize_item_owner
    return if current_user == @item.user

    flash[:alert] = 'この操作は許可されていません。'
    Rails.logger.warn("Unauthorized access attempt by #{current_user.email} on item #{@item.id}")
    redirect_to root_path
  end
end
