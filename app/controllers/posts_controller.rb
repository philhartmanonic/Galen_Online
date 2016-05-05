class PostsController < ApplicationController
  require "base64"
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:blog, :show, :callbacks, :all_blog]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @recents = Post.order("created_at desc").limit(5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @recents = Post.order("created_at desc").limit(4).offset(1)
    @last = Post.last
    @posts = Post.all
    @comments = Comment.where(post_id: @post.id).sort_by{|p| -p.score}
    @post = Post.find(params[:id])
  end

  def blog
    @recents = Post.order("created_at desc").limit(4).offset(1)
    @last = Post.last
    @posts = Post.all
    refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    token = refresh["access_token"]
    raw_recent = HTTParty.get('https://api.spotify.com/v1/me/top/artists?limit=5&time_range=short_term', headers: {"Authorization" => "Bearer " + token})
    recent_bands = []
    raw_recent["items"].each {|b| recent_bands << {id: b["id"], name: b["name"], genres: b["genres"], picture: b["images"][-1]["url"], picture2: b["images"][-2]["url"], popularity: b["popularity"]}}
    @recent_bands = recent_bands.sort_by {|b| (b[:popularity] * -1)}
    raw_all = HTTParty.get('https://api.spotify.com/v1/me/top/artists?limit=5&time_range=long_term', headers: {"Authorization" => "Bearer " + token})
    all_bands = []
    raw_all["items"].each {|b| all_bands << {id: b["id"], name: b["name"], genres: b["genres"], picture: b["images"][-1]["url"], popularity: b["popularity"]}}
    @all_bands = all_bands.sort_by {|b| (b[:popularity] * -1)}
  end

  def callbacks
    if params['code'].present?
      a = params['code']
      puts request.env['omniauth.auth']
    end
    if params['access_token'].present?
      @dostuff = params['access_token'] + ' ' + params["token_type"] + ' ' + params['expires_in'].to_s + ' ' + params["refresh_token"]
    end
  end

  def all_blog
    @posts = Post.paginate(page: params[:page], per_page: 5).order("created_at desc")
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
      params.require(:post).permit(:title, :body, :user_id, :main_image, user_attributes: [:id, :email, :username], comments_attributes: [:body, :score], votes_attributes: [:up])
    end
end
