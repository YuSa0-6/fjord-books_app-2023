# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :ensure_editor, only: [:destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @commentable.comments
      render_commentable_show
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def ensure_editor
    @comment = Comment.find(params[:id])
    redirect_to commentable_path(@comment.commentable_id) if @comment.user_id != current_user.id
  end
end
