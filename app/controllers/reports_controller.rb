require 'json'
class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  skip_before_filter  :verify_authenticity_token


  #respond_to :html

  def index
    redirect_to :home
  end

  def show
    respond_to do |format|
      format.html { render html: @report }
      format.json { render json: @report }
    end
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
    #@json = params["json"].gsub("\n", "").gsub("\r","").gsub(/  /, "")
    #@array = JSON.parse(@json)
    @array = params["reports"]
    @array.each do |e|
      #logger.debug e
      if Device.exists?(:id => params[:device_id])
        @device = Device.find(params[:device_id])
        @api_key = @device.api_key
      else
        @device = Device.create(:id => params[:device_id])
        @api_key = @device.api_key
      end

      @report = Report.create(:device_id => params[:device_id], :restaurant_id => params[:restaurant_id], :user_id =>params[:user_id], :when => DateTime.parse(e["when"]), :preptime => e["preptime"], :item => e["item"], :order_number => e["order_number"])
    end
    #flash[:notice] = "Entry added successfully"
    respond_to do |format|
      format.html { render html: @report }
      format.json { render json: @report }
    end
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
