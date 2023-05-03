class CommentsController < ApplicationController
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response


    # GET
    def index
        comments = Comment.all
        render json: comments, status: :ok
    end

    # GET /:id
    def show
        comment = find_comment
        render json: comment, status: :ok
    end

    # POST
    def create
        comment = Comment.create!(comment_params)
        render json: comment, status: :created
    end

    # PATCH/PUT
    def update
        comment = find_comment
        comment.update!(comment_params)
        render json: comment, status: :accepted
    end

    # DELETE
    def destroy
        comment = find_comment
        comment.destroy
        head :no_content
    end

    private

    def find_comment
        Comment.find(params[:id])
    end

    def comment_params
        params.permit(:content, :article_id, :user_id)
    end

    def render_not_found_response
        render json: { error: "Comment not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
    end
end
