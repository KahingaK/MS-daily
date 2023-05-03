class ProfilesController < ApplicationController
  before_action :authorize_request
    before_action :set_profile, only: %i[ show update destroy ]

    # GET /profiles
    def index
      @profiles = Profile.all
      render json: @profiles.map { |profile| ProfileSerializer.new(profile).serializable_hash[:data][:attributes] }, status: :ok
    end
  
    # GET /profiles/1
    def show
      @profile = find_profile
      render json: ProfileSerializer.new(@profile).serializable_hash[:data][:attributes], status: :ok
    end
  
    # POST /profiles
    def create
      @profile = Profile.new(profile_params)
  
      if @profile.save
        render @profile, status: :created, location: @profile
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /profiles/1
    def update
      if @profile.update(profile_params)
        render @profile, status: :ok
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /posts/1
    def destroy
      @profile = find_profile
      @profile.destroy
    end
  
  
    private
  
    def find_profile
      Profile.find(params[:id])
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:full_name, :bio, :user_id, :image)
    end
end
