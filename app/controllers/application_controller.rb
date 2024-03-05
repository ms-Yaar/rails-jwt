class ApplicationController < ActionController::Base
  include JsonWebToken
  before_action :authenticate_request
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  private

  def authenticate_request
    header = request.headers["Authorization"]

    unless header
      render json: { error: "Missing Authorization header. Please include the Authorization header with a valid JWT." }, status: :unauthorized
      return
    end

    header = header.split(" ").last

    begin
      decode = jwt_decode(header)
      @current_user = User.find(decode&.dig(:user_id))
    rescue JWT::ExpiredSignature
      render json: { error: "JWT has expired. Please obtain a new JWT for authentication." }, status: :unauthorized
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      render json: { error: "Invalid JWT: #{e.message}. Please provide a valid JWT for authentication." }, status: :unauthorized
    end
  end
end
