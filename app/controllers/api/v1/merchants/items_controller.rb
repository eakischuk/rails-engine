class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
    render json: ItemSerializer.format_items(items)
  end
end
