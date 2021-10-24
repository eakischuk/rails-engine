class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = find_per_page
    page = find_page
    merchants = Merchant.all.offset(page * per_page).limit(per_page)
    render json: MerchantSerializer.format_merchants(merchants)
  end

  private

  def find_page
    if params[:page].to_i == 0
      params[:page].to_i
    else
      params[:page].to_i - 1
    end
  end

  def find_per_page
    if params[:per_page].present?
      params[:per_page].to_i
    else
      20
    end
  end
end
