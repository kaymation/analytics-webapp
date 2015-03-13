class GraphsController < ApplicationController
	def show
	end

	def create
		@graph = Graph.new
		@graph.restaurant_id = params[:restaurant_id]
		@graph.user_id = params[:user_id]
		@body = {graphType: params[:graphType], station_name: params[:station]}
		@graph.body = @body.to_s
		@graph.save!
		@graphs = Graph.where(restaurant_id: params[:restaurant_id])
		@graphs.each do |g|
			logger.debug "we gotta graph #{g.id}"
		end
		render :json => @graph.assemble_pre_json
	end
end
