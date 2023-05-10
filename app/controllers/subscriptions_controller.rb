class SubscriptionsController < ApplicationController
  before_action :authorize_request
  # GET /subscriptions
    # Show all subscriptions and articles in the subscribed categories
    def index
      current_user = @current_user
      subscriptions = current_user.subscriptions.includes(category: :articles)
      render json: subscriptions, include: { category: { include: :articles } }
    end


    # POST /subscriptions Subscribe to article categories
  
    def create
      current_user = @current_user
      if current_user
          subscription = Subscription.create(user_id: current_user.id, category_id: params[:category_id])
          render json: subscription, status: :accepted, notice: "Subscriptions saved successfully."
      else
        render json: { error: "User not found" }, status: :unprocessable_entity
      end
    end
        
   
        # Unsubscribe from category
    def destroy
      current_user = @current_user
      category = Category.find(params[:id])
      subscription = current_user.subscriptions.find_by(category_id: category.id)
      
      if subscription
        subscription.destroy
        head :no_content
      else
        render json: { error: "Subscription not found" }, status: :unprocessable_entity
      end
    end
          

end
