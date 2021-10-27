class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:name].present?
      render json: merchant_find
    else
      bad_request
    end
  end

  private

  def merchant_find
    found_merchants = Merchant.search_by_name(params[:name])
    if found_merchants.empty?
      MerchantSerializer.format_nil
    else
      MerchantSerializer.format_merchant(found_merchants.first)
    end
  end
end
