class ApplicationController < ActionController::Base
    before_action :authorize_request

    # # Enable sessions
    # include ActionController::Cookies

    # make available
    helper_method :current_user, :ensure_current_user, :image_url

    private

    # def ensure_current_user
    #     if current_user.nil?
    #         render json: { error: 'Kindly log in to contribute'}, status: :unauthorized
    #     end
    # end

    # def current_user
    #     if session[:user_id]
    #         @current_user ||= User.find(session[:user_id]) 
    #     end
    # end

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
    
        begin
          decoded = JWT.decode(header, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
          @current_user_id = decoded[0]['user_id']
          @current_user = User.find(@current_user_id)
        rescue JWT::DecodeError
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      end

    def image_url
        Rails.application.routes.url_helpers.url_for(image) if image.attached?
    end

end
