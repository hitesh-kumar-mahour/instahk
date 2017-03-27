class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_owner, only: [:edit, :update, :destroy]
     def comment_owner
       @post=Post.find(params[:post_id])
       @comment=@post.comments.find(params[:id])
      unless @comment.user_id == current_user.id
       flash[:notice] = 'Access denied as you are not owner of this Job'
       redirect_to post_path(@post)
      end
     end
  def destroy
    @post=Post.find(params[:post_id])
    @comment=@post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  def create
      @post= Post.find( params[:post_id] )
      @comment= @post.comments.create(params[:comment].permit(:body,:user_id))
      redirect_to post_path(@post)
  end
  # private
  #
  #   def permit_comment
  #     params.require(:comment).permit(:name,:body)
  #   end
end
