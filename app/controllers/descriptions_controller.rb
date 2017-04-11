class DescriptionsController < ApplicationController
  def new
    @user= User.find(params[:id] )
    @desc=User.description.new
  end

  def create

  end

  def edit
  end

  def destroy
  end
end
