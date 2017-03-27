class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def profile
    @user= User.find(params[:id] )
    @posts=@user.posts.all.order('created_at DESC')
  end
end
