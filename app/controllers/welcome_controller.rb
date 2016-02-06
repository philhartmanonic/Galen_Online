class WelcomeController < ApplicationController
  def welcome
  	@posts = Post.all
  	@recents = Post.order("created_at desc").limit(5)

  end
  def about
  end
end
