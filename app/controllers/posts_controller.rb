class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => :blog

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @recents = Post.order("created_at desc").limit(5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @recents = Post.order("created_at desc").limit(5)
    @posts = Post.all
    @comments = Comment.where(post_id: @post.id).sort_by{|p| -p.score}
    @post = Post.find(params[:id])
  end

  def blog
    @recents = Post.order("created_at desc").limit(5)
    @posts = Post.includes(:comments).all
  end

  def all_blog
    @posts = Post.order("created_at desc")
  end

  # GET /posts/new
  def new
    @post = Post.new
    @recents = Post.order("created_at desc").limit(5)
    @users = User.all
    @user = User.find(current_user)
    @roles = Role.all
    @role = Role.where(id: @user.role_id)
  end

  # GET /posts/1/edit
  def edit
    @users = User.all
    @roles = Role.all
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @post = Post.find(params[:id])
    @post.votes.create(user_id: current_user.id, up: true)
    redirect_to post_path
  end

  def downvote
    @post = Post.find(params[:id])
    @post.votes.create(user_id: current_user.id, up: false)
    redirect_to post_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id, user_attributes: [:id, :email, :username], comments_attributes: [:body, :score], votes_attributes: [:up])
    end
end
