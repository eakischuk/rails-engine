class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if valid_quantity?
      merchants = Merchant.by_revenue(params[:quantity].to_i)
      render json: MerchantSerializer.format_merchants_revenue(merchants)
    else
      bad_request
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.format_merchant_revenue(merchant)
  end
end
