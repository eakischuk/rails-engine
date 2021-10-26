class Api::V1::Items::MerchantController < ApplicationController
  def show
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.format_merchant(merchant)
  end
end
