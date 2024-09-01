class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_item_owner, only: [:edit, :update, :destroy]

  def index
    @items = Item.order(created_at: :desc)
    Rails.logger.info("Item index accessed by #{current_user&.email || 'Guest'}")
  end

  def show
    # 商品の詳細情報は set_item メソッドで取得されているので、ここでは特別な処理は不要です。
    Rails.logger.info("Item #{@item.id} viewed by #{current_user&.email || 'Guest'}")
  end

  def new
    @item = Item.new
    Rails.logger.info("New item creation page accessed by #{current_user.email}")
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      Rails.logger.info("Item #{@item.id} created successfully by #{current_user.email}")
      redirect_to root_path, notice: t('items.create.success')
    else
      Rails.logger.error("Item creation failed: #{@item.errors.full_messages.join(', ')}")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    return unless item_already_ordered?

    Rails.logger.warn("Attempt to edit already ordered item #{@item.id} by #{current_user.email}")
    redirect_to root_path, alert: t('items.edit.already_ordered')
  end

  def update
    if item_already_ordered?
      redirect_to root_path, alert: t('items.update.already_ordered')
    else
      @item.image.attach(@item.image.blob) if params[:item][:image].blank? && @item.image.attached?

      if @item.update(item_params)
        redirect_to item_path(@item), notice: t('items.update.success')
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @item.destroy
      Rails.logger.info("Item #{@item.id} destroyed by #{current_user.email}")
      redirect_to root_path, notice: t('items.destroy.success')
    else
      Rails.logger.error("Item deletion failed: #{@item.errors.full_messages.join(', ')}")
      redirect_to edit_item_path(@item), alert: t('items.destroy.failure')
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
  end

  def authorize_item_owner
    return if current_user == @item.user

    flash[:alert] = t('items.not_authorized')
    Rails.logger.warn("Unauthorized access attempt by #{current_user.email} on item #{@item.id}")
    redirect_to root_path
  end

  def item_already_ordered?
    @item.order.present?
  end
end
