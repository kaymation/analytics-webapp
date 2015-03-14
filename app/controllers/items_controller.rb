class ItemsController < ApplicationController
	def create
		@item = Item.new
	@itemparams = params[:item]
    @item.foodmenu_id = @menu.id
    @item.name = @itemparams[:name]
    @item.price = @itemparams[:price]
    @item.save!
    @items = Item.where(foodmenu_id: @menu.id)
		respond_to do |format|
			format.html
			format.js  { render partial: '/restaurants/items'}
			format.json
		end
	end
end
