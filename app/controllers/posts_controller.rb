class PostsController < ApplicationController
before_action :authenticate_user!,except: [:index]
before_action :post_owner, only: [:edit, :update, :destroy]

  def post_owner
    @post= Post.find( params[:id] )
   unless @post.user_id == current_user.id
    flash[:notice] = 'Access denied as you are not owner of this Post'
    redirect_to posts_path
   end
  end

  def index
    @posts=Post.all.order('created_at DESC')
  end

  def show
    @post= Post.find( params[:id] )
  end

  def destroy
    @post= Post.find( params[:id] )
    @post.destroy
      flash[:success]='Post deleted successfuly'
    redirect_to posts_path
  end

  def new
    @post=Post.new
  end

  def create
    @post=Post.new(permit_post)
    if @post.save
      flash[:success]='Post created successfuly'
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
      flash[:success]='Post updated successfuly'
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def like
  @post = Post.find(params[:id])
  @post.liked_by current_user
  respond_to do |format|
    format.html { redirect_to :back }
    format.js { render layout: false }
  end
end

def unlike
  @post = Post.find(params[:id])
  @post.unliked_by current_user
  respond_to do |format|
    format.html { redirect_to :back }
    format.js { render layout: false }
  end
end

  private

    def permit_post
      params.require(:post).permit(:image,:description,:user_id)
    end
end
