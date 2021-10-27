class Api::V1::Items::SearchController < ApplicationController
  def index
    if params_present?
      if mixed_params?
        bad_request
      else
        items = item_search
        render json: ItemSerializer.format_items(items)
      end
    else
      bad_request
    end
  end

  private

  def params_present?
    params[:name].present? ||
    params[:min_price].present? ||
    params[:max_price].present?
  end

  def mixed_params?
    params[:name].present? && params[:min_price].present? ||
    params[:name].present? && params[:max_price].present?
  end

  def item_search
    if params[:name].present?
      Item.search_by_name(params[:name])
    elsif params[:max_price].present? && params[:min_price].present?
      Item.in_price_range(params[:min_price], params[:max_price])
    elsif params[:min_price].present?
      Item.price_above(params[:min_price])
    elsif params[:max_price].present?
      Item.price_below(params[:max_price])
    end
  end
end
