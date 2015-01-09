class CommentsController < ApplicationController
  def create
    @production = Production.find(params[:production_id])
    @comment = @production.comments.build
    @comment.assign_attributes(comment_params)
    if @comment.valid?
      @comment.user_id = current_or_guest_user.id
      # Using the Sanitize gem to strip all markup from the user input.
      #   This will make it safe to display raw, unescaped comments.
      @comment.content = Sanitize.fragment(@comment.content)
      @comment.parse_symbols
      @comment.save!
      @comments = @production.comments.page(1)
      @comment = Comment.new
      respond_to do |format|
        format.html { redirect_to @production }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @production, message: 'Your comment is blank!' }
        format.js { render 'comment_errors' }
      end
    end
  end
  
  def index
    @production = Production.find(params[:production_id])
    @comments = @production.comments.page(params[:comments_page])
    respond_to do |format|
      format.html { redirect_to production_path(id: @production.id, comments_page: params[:comments_page]) }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @production = Production.find(params[:production_id])
    @comments = @production.comments.page(1)
  end
  
  private # ====================================================================================================
  
  def comment_params
    params.require(:comment).permit(:content, :username)
  end
end