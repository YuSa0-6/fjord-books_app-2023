class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.save
    redirect_to reports_path
  end

  def edit; end

  def index
    @reports = Report.all
  end

  def show
    @comment = Comment.new
    @comments = @report.comments.order(:id)
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('controller.common.notice_update', name: Report.model_name.human)
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end
end
