class AuthenticationController < ApplicationController
  include JsonWebToken
 skip_before_action :authenticate_request
  # include JsonWebToken

 def login
   @user = User.find_by_email(params[:email])

   if @user&.authenticate(params[:password])
     token = JsonWebToken.jwt_encode(user_id: @user.id)
     @user.update(token: token)

     render json: { token: token }, status: :ok 
   else
     render json: { error: 'unauthorized' }, status: :unauthorized
   end
 end
end
