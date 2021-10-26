class Api::V1::ItemsController < ApplicationController
  def index
    per_page = find_per_page
    page = find_page
    items = Item.all.offset(page * per_page).limit(per_page)
    render json: ItemSerializer.format_items(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.format_item(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.format_item(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.format_item(item)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
