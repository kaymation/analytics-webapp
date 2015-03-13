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

  def authenticate
    @api_key = params['key']
    @device = Device.where(api_key: api_key).first if @api_key

    unless @device
      head status: :unauthorized
      return false
    end
  end

  def edit
  end

  def create
    @report = Report.new

    @json = params["json"].gsub("\n", "").gsub("\r","").gsub(/  /, "")
    @array = JSON.parse(@json)

    @array.each do |e|
      logger.debug e.to_s
      Report.create(:device => params[:device_id], :restaurant_id => params[:restaurant_id], :user_id =>params[:user_id], :when => DateTime.parse(e["when"]), :preptime => e["preptime"], :item => e["item"], :order_number => e["order_number"])
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
