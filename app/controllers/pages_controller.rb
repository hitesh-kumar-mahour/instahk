class PagesController < ApplicationController
  before_action :authenticate_user!

    def profile
      @user= User.find(params[:id] )
      @posts=@user.posts.all.order('created_at DESC')
    end

    def index
       @users = User.search(params[:search]).where.not(id: current_user.id)
    end

    def following
      @title = "Following"
      @user  = User.find(params[:id])
      @fusers = @user.following.paginate(page: params[:page])
      render '_show_follow'
    end

    def followers
      @title = "Followers"
      @user  = User.find(params[:id])
      @fusers = @user.followers.paginate(page: params[:page])
      render '_show_follow'
    end

end
