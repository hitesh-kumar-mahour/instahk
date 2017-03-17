class PostsController < ApplicationController
before_action :authenticate_user!,except: [:index]
  def index
    @posts=Post.all.order('created_at DESC')
  end

  def show
    @post= Post.find( params[:id] )
  end

  def destroy
    @post= Post.find( params[:id] )
    @post.destroy
    redirect_to posts_path
  end

  def new
    @post=Post.new
  end

  def create
    @post=Post.new(permit_post)
    if @post.save
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def edit
      @post= Post.find( params[:id] )
  end

  def update
    @post= Post.find( params[:id] )
    if @post.update(params[:post].permit(:image,:description))
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  private

    def permit_post
      params.require(:post).permit(:image,:description)
    end
end
