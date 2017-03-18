class CommentsController < ApplicationController

  def destroy
    @post=Post.find(params[:post_id])
    @comment=@post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  def create
      @post= Post.find( params[:post_id] )
      @comment= @post.comments.create(params[:comment].permit(:name,:body))
      redirect_to post_path(@post)
  end
  # private
  #
  #   def permit_comment
  #     params.require(:comment).permit(:name,:body)
  #   end
end
