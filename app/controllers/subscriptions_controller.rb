class SubscriptionsController < ApplicationController
  before_action :authorize_request

    # POST /subscriptions Subscribe to article categories
  
    def create
      current_user = User.find_by(id: (@current_user_id))
      if current_user
        params[:category_ids].each do |cat_id|
          subscription = Subscription.create(user: current_user, category_id: cat_id.to_i)
        end
        render json: subscription, status: :accepted, notice: "Subscriptions saved successfully."
      else
        render json: { error: "User not found" }, status: :unprocessable_entity
      end
    end
        
    # DELETE /subscription Unsubscribe from category
    def destroy
      current_user = User.find_by(id: @current_user_id)
      subscription = Subscription.find(params[:id])
      if current_user && current_user == subscription.user
        subscription.destroy
        head :no_content
      else 
        render json: { error: "Subscription not found or unauthorized access" }, status: :unprocessable_entity
      end
    end
       

end
