class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :connect, :devices, :upload, :reports, :menu, :new_item, :analyze]
  before_action :pull_listing
  before_action :get_reports, only: [:reports, :show]
  before_action :get_menu, only: [:menu, :new_item]

  respond_to :html

def pull_listing
  if user_signed_in?
    @activepage = request.env['PATH_INFO']
    @listing = Restaurant.where( user_id: current_user.id).order('created_at DESC')
  end
end

  def get_reports
     @reports = Report.where(restaurant_id: @restaurant.id)
     @dates = @reports.map { |e| [e.when, e.preptime]  }
  end

  def index
    @signedin = 0
    @restaurants = Restaurant.all
      if user_signed_in?
        render :index and return
      else
        redirect_to "/", :alert => "Please login first."
      end
  end

  def get_menu
    logger.debug "shit shit shit name is #{@restaurant}"
    @menu = FoodMenu.where(restaurant_id:  @restaurant.id).first
    unless @menu
      @menu = FoodMenu.new(restaurant_id:   @restaurant.id)
      @menu.save!
    end 
    @items = Item.where(foodmenu_id: @menu.id)
    @item = Item.new
    flash.alert = "Looks like you haven't added any items to this restaurant's menu yet, how about you add a few?" if @items.empty?

  end

  def new_item
    @itemparams = params[:item]
    @item.foodmenu_id = @menu.id
    @item.name = @itemparams[:name]
    @item.price = @itemparams[:price]
    @item.save!
    @items = Item.where(foodmenu_id: @menu.id)
    @items.each do |item|
      logger.debug item.name
    end
    respond_to do |format|
      format.js {render partial: 'items'}
    end

  end

  def menu

  end

  def show
 
    # @chart = LazyHighCharts::HighChart.new('graph') do |f|
    #   f.title(:text => "Demo Chart")
 
    #    f.series(:name=> "Value:", :data => @dates)

    #   f.yAxis [
    #     {:title => {:text => "Value", :margin => 70} },
    #   ]

    #   f.xAxis [
    #     {:title => {:text => "Date", :margin => 70} },
    #   ]

    #   f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    #   f.chart({:defaultSeriesType=>"spline"})
    # end

    respond_with(@restaurant)
  end

  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end

  def edit
  end

  def analyze
    @reports = Report.where(restaurant_id: @restaurant.id)
    @reports.each do |r|
      logger.debug r.device_id
    end
    @devices = @reports.map { |r| Device.find(r.device_id) }.uniq
    @devices.each do |r|
      logger.debug r.station_name
      
    end
    @graph = Graph.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    @restaurant.save
    respond_with(@restaurant)
  end

  def devices
    @reports = Report.where(restaurant_id: @restaurant.id)
    @ids = @reports.map{|e| e.device_id}
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
      logger.debug "you already know"
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :user_id)
    end
end
