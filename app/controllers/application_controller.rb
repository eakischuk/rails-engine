class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request
  rescue_from ActiveRecord::StatementInvalid, with: :bad_request
  after_action :set_code_on_create, only: [:create]

  private

  def record_not_found
    render plain: "404 Not Found", status: 404
  end

  def bad_request
    render plain: "400 Bad Request", status: 400
  end

  def set_code_on_create
    response.status = 201 if response.status == 200
  end

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
