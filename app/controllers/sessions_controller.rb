class SessionsController < ApplicationController
    # Login

    skip_before_action :authorize_request, only: :create
    def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
          render json: {message: "loggedin successfully",user: user, token: token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    
    # def create
    #     user = User.find_by(email: params[:email])
    #     if user && user.authenticate(params[:password])
    #         session[:user_id] = user.id
    #         render json: user, status: :ok
    #     else
    #         render json: { errors: "Invalid username or password"}, status: :unauthorized
    #     end
    # end
    
    # Delete
    def destroy
        token.delete :user_id
        head :no_content
    end
end
