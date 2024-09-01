class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  # before_action :set_item, only: [:show, :edit, :update, :destroy]
  # before_action :authorize_item_owner, only: [:edit, :update, :destroy]

  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: t('items.create.success')
    else
      Rails.logger.error "Item creation failed: #{@item.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  # def show
  # end

  # def edit
  #   if item_already_ordered?
  #     redirect_to root_path, alert: t('items.edit.already_ordered')
  #   end
  # end

  # def update
  #   if item_already_ordered?
  #     redirect_to root_path, alert: t('items.update.already_ordered')
  #   elsif @item.update(item_params)
  #     redirect_to item_path(@item), notice: t('items.update.success')
  #   else
  #     Rails.logger.error "Item update failed: #{@item.errors.full_messages.join(', ')}"
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   if @item.destroy
  #     redirect_to root_path, notice: t('items.destroy.success')
  #   else
  #     Rails.logger.error "Item deletion failed: #{@item.errors.full_messages.join(', ')}"
  #     redirect_to edit_item_path(@item), alert: t('items.destroy.failure')
  #   end
  # end

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :condition_id, :shipping_fee_id, :prefecture_id,
                                 :delivery_time_id, :price).merge(user_id: current_user.id)
  end

  # def set_item
  #   @item = Item.find(params[:id])
  # end

  # def authorize_item_owner
  #   unless current_user == @item.user
  #     flash[:alert] = t('items.not_authorized')
  #     redirect_to root_path
  #   end
  # end

  # def item_already_ordered?
  #   @item.order.present?
  # end
end
