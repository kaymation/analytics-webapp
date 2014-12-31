class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @signedin = 0
    @restaurants = Restaurant.all
    # respond_with(@restaurants)
     if user_signed_in?
      render :index and return
    else
       render  "home/index.html.erb"
     end
  end

  def show
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
    @restaurant.save
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
