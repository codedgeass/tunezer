class CommentsController < ApplicationController
  def create
    @concert = Concert.find(params[:concert_id])
    @comment = @concert.comments.build
    @comment.assign_attributes(comment_params)
    if @comment.valid?
      @comment.user_id = current_or_guest_user.id
      # Using the Sanitize gem to strip all markup from the user input.
      #   This will make it safe to display raw, unescaped comments.
      @comment.content = Sanitize.fragment(@comment.content)
      @comment.parse_symbols
      @comment.save!
      @comments = @concert.comments.page(1)
      @comment = Comment.new
      respond_to do |format|
        format.html { redirect_to @concert }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @concert, message: 'Your comment is blank!' }
        format.js { render 'comment_errors' }
      end
    end
  end
  
  def index
    @concert = Concert.find(params[:concert_id])
    @comments = @concert.comments.page(params[:comments_page])
    respond_to do |format|
      format.html { redirect_to concert_path(id: @concert.id, comments_page: params[:comments_page]) }
      format.js
    end
  end
  
  def show
    @username = params[:username]
    render 'comment_reply'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @concert = Concert.find(params[:concert_id])
    @comments = @concert.comments.page(1)
  end
  
  private # ====================================================================================================
  
  def comment_params
    params.require(:comment).permit(:content, :username)
  end
end