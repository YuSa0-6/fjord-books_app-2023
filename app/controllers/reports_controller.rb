class ReportsController < ApplicationController
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.save
    redirect_to reports_path
  end

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
  end

  private

  def report_params
    params.require(:report).permit(:title, :body)
  end
end
