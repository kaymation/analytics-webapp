require 'json'
class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]


  respond_to :html

  def index
    @reports = Report.all
    respond_with(@reports)
  end

  def show
    respond_with(@report)
  end

  def new
    @report = Report.new
    respond_with(@report)
  end

  def edit
  end

  def create
    @report = Report.new

    @json = params["json"].gsub("\n", "").gsub("\r","").gsub(/  /, "")
    logger.debug @json
    logger.debug 'dildo hat'
    @array = JSON.parse(@json)

    @array.each do |e|
      logger.debug e.to_s
      Report.create(:device => params[:device_id], :restaurant_id => params[:restaurant_id], :user_id =>params[:user_id], :date => e["date"], :value => e["value"])
    end
    flash[:notice] = "Entry added successfully"
    render :success
  end

  def update
    @report.update(report_params)
    respond_with(@report)
  end

  def destroy
    @report.destroy
    redirect_to :back
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end



    def report_params
      params.require(:report).permit(:device, :date, :value, :restaurant_id, :user_id)
    end
end
