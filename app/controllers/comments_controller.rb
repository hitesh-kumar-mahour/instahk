class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_owner, only: [:edit, :update, :destroy]
     def comment_owner
       @post=Post.find(params[:post_id])
       @comment=@post.comments.find(params[:id])
      unless @comment.user_id == current_user.id||@comment.post.user_id==current_user.id
       flash[:notice] = 'Access denied as you are not owner of this Job'
       redirect_to post_path(@post)
      end
     end
  def destroy
    @post=Post.find(params[:post_id])
    @comment=@post.comments.find(params[:id])
    @comment.destroy
    flash[:success]='Comment deleted successfuly'
    redirect_to post_path(@post)
  end

  def create
      @post= Post.find( params[:post_id] )
      @comment= @post.comments.create(params[:comment].permit(:body,:user_id))
      flash[:success]='Comment created successfuly'
      redirect_to post_path(@post)
  end

  def edit
    @post= Post.find( params[:post_id] )
    @comment=@post.comments.find(params[:id])
  end

  def update
    @post= Post.find( params[:post_id] )
    @comment=@post.comments.find(params[:id])
    if @comment.update(params[:comment].permit(:body,:user_id))
        flash[:success]='Comment updated successfuly'
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end
  # private
  #
  #   def permit_comment
  #     params.require(:comment).permit(:name,:body)
  #   end
end
