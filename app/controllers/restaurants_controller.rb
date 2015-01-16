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
     @dates = @reports.map { |e| [e.date, e.value]  }
  end

  def index
    @signedin = 0
    @restaurants = Restaurant.all
     if user_signed_in?
      render :index and return
    else
       render  "home/index.html.erb"
     end
  end

  def show
 
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Demo Chart")
 
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
