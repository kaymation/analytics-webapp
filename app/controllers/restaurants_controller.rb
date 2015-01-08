class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :connect, :devices, :upload, :reports]
  before_action :pull_listing
  before_action :get_reports, only: [:reports, :show]

  respond_to :html

def pull_listing
  if user_signed_in?
    @activepage = request.env['PATH_INFO']
    @listing = Restaurant.where( user_id: current_user.id).order('created_at DESC')
  end
end

  def get_reports
     @reports = Report.where(restaurant_id: @restaurant.id)
     # @dates = Report.select('report.date').where(restaurant_id: @restaurant.id)
     @dates = @reports.map { |e| [e.date, e.value]  }
  end

  def index
    @signedin = 0
    @restaurants = Restaurant.all
    # respond_with(@restaurants)
     if user_signed_in?
      # @listing = Restaurant.where( user_id: current_user.id).order('created_at DESC')
      render :index and return
    else
       render  "home/index.html.erb"
     end
  end

  def show
    # @listing = Restaurant.where( user_id: current_user.id).order('created_at DESC')
    # @tempdates = @reports.select('report.date').references(:reports)
    # @dates = []
    # @tempdates.each do |td|
    #   @dates << td.date
    # end
    # @values = []
    # @dates.each do |d|
    #   @temp = @reports.bsearch{|e| (e.date == d)}
    #   @values << @temp.value
    # end

    # @utc_date = []
    # @dates.each do |date|
    #   @utc_date << date.to_s
    # end


    # @values = (@reports.map{ |e| e.value})
    # @chart = LazyHighCharts::HighChart.new('graph') do |c|
    #   c.title(:text => "Demo Overview Chart")
    #   c.series(:type => 'line', :name => 'Temperature', :data => @values, )
    #   c.xAxis[type: 'date', ]
    # end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Demo Chart")
      logger.debug @dates
      logger.debug "utc_date"
      # logger.debug @values
      logger.debug "values"
      # f.xAxis(categories: @utc_date)
      # f.series(:name => "Value",  :data => @values)
       f.series(:name=> "Value:", :data => @dates)

      f.yAxis [
        {:title => {:text => "Value", :margin => 70} },
      ]

      f.xAxis [
        {:title => {:text => "Date", :margin => 70} },
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"spline"})
    end

    logger.debug "dildo hat: #{@pairs}"
    respond_with(@restaurant)
  end

  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    @restaurant.save
    respond_with(@restaurant)
  end

  def devices
    @reports = Report.where(restaurant_id: @restaurant.id)
    @ids = @reports.map{|e| e.device}
  end

  def upload
  end

  def reports
    @reports = Report.where(restaurant_id: @restaurant.id)
  end

  def connect
    respond_with(@restaurant)
  end



  def update
    @restaurant.update(restaurant_params)
    respond_with(@restaurant)
  end

  def destroy
    @restaurant.destroy
    respond_with(@restaurant)
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :user_id)
    end
end
