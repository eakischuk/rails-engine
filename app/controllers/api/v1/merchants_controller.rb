class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = find_per_page
    page = find_page
    merchants = Merchant.all.offset(page * per_page).limit(per_page)
    render json: MerchantSerializer.format_merchants(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.format_merchant(merchant)
  end
end
