class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:name].present?
      merchant = Merchant.search_by_name(params[:name]).first
      render json: MerchantSerializer.format_merchant(merchant)
    else
      bad_request
    end
  end
end
