class UsersController < ApplicationController
  include JsonWebToken
  skip_before_action :authenticate_request, only: [:create]
  
  def index
   @users= User.all
   render json: @users, status: :ok
  end
  
  def show
   @user=User.find(params[:id])
   render json: @user, status: :ok
  end
  
 
    def create
      Rails.logger.debug("Incoming request parameters: #{params.inspect}")

      begin
        @user = User.new(user_params)
        @user.token = JsonWebToken.jwt_encode(user_id: @user.id)
  
        if @user.save
          render json: { user: @user, token: @user.token }, status: :ok
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: "Bad Request: Missing required parameters. Please provide the necessary parameters: #{e.param}" }, status: :bad_request
      end
    end
  
  def update
   unless @user.update(user_params)
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
   end
  end
  
  def destroy
   @user.destroys
  end
  
  private 
  def user_params
    params.require(:user).permit(:email, :password,:username,:name)
  rescue ActionController::ParameterMissing => e
    render json: { error: "Bad Request: Missing required parameters. Please provide the necessary parameters: #{e.param}" }, status: :bad_request
  end
  end
  
  
  