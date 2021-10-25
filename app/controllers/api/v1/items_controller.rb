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
end
