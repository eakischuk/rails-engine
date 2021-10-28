class Api::V1::RevenueController < ApplicationController
  def show
    if dates_present? && dates_valid? # params[:start_date].present? && params[:end_date].present?
      revenue = Invoice.total_revenue_between(params[:start], params[:end])
      render json: RevenueSerializer.format_date_range_revenue(revenue)
    else
      bad_request
    end
  end

  private

  def dates_present?
    params[:start].present? && params[:end].present?
  end

  def dates_valid?
    format = '%Y-%m-%d'
    DateTime.strptime(params[:start], format)
    DateTime.strptime(params[:end], format)
    true
  end
end
