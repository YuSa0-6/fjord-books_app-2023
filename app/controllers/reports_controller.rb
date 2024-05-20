# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :ensure_editor, only: %i[edit destroy update]
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
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end

  def ensure_editor
    @report = Report.find(params[:id])
    return if @report.user_id == current_user.id

    redirect_to report_path(@report.id)
  end
end
