class UsersController < ApplicationController
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    skip_before_action :authorize_request, only: :create 
    # GET /Users
    def index
        users = User.all
        render json: users, status: :ok
    end

    # # GET /me
    # def show
    #     user = User.find(session[:user_id])
    #     if user
    #         render json: user, status: :ok
    #     else 
    #         render json: { error: 'No user is currently logged in'}, status: :unauthorized
    #     end
    # end


    # POST /signup

    
    def create
      user = User.new(user_params)
      if user.save
        token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
        
        render json: {user: user, token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end


    # def create
    #     user = User.create(user_params)
    #     # Save user in session's hash
    #     if user.valid?
    #         session[:user_id] = user.id
    #         render json: user, status: :created
    #     else
    #         render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    #     end

    # end

    #POST register_user

    # PATCH /users/:id
    def update
        user = find_user
        if user
            if @current_user.admin?
                user.update(user_params)
                render json: user, status: :accepted
            else
                render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
            end
        else
            render json: { error: "User not found "}, status: :not_found
        end
    end

    # DELETE /users/:id
    def destroy
        user = find_user
        if user
            if @current_user.admin?
                user.destroy
                head :no_content
            else
                render json: { error: "Unauthorized access" }, status: :forbidden
            end
        else
            render json: { error: "User not found"}, status: :not_found
        end
    end

    private

    def find_user
        User.find(params[:id])
    end

    def user_params
        params.permit(:username, :email, :password)
    end

    def render_not_found_response
        render json: { error: "User not found" }, status: :not_found
    end
    
    def render_unprocessable_entity_response(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
    end
end
