# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    # @items = Item.order(created_at: :desc)
  end

  def new
    # @item = Item.new
  end

  def create
    # @item = Item.new(item_params)
    # if @item.save
    #   redirect_to root_path
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def show
  end

  def edit
  end

  def update
    # if @item.update(item_params)
    #   redirect_to item_path(@item)
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  private

  # def item_params
  #   params.require(:item).permit(:image, :title, :description, :category_id, :condition_id, :shipping_cost_id, :region_id,
  #                                :delivery_date_id, :price).merge(user_id: current_user.id)
  # end

  # def set_item
  #   @item = Item.find(params[:id])
  # end

  # def correct_user
  #   redirect_to root_path unless @item.user_id == current_user.id
  # end
end
