class CommentsController < ApplicationController
  def new
    @post = Post.find(params[:id])
    @comment = @post.comments.new
  end

  def create
    @post = Post.find(params[:id])
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @post = Post.where(id: params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.votes.create(user_id: current_user.id, up: true)
    redirect_to :back
  end

  def downvote
    @post = Post.where(id: params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.votes.create(user_id: current_user.id, up: false)
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :post_id, votes_attributes: [:up], users_attributes: [:email])
    end
end
