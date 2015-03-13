class Graph < ActiveRecord::Base
	belongs_to :restaurant

	def assemble_pre_json
		@graph_params = eval(body)
		if @graph_params[:graphType] == "Prep Time Analysis"
			get_preptime_analysis_data(@graph_params)
		else
			get_order_load_analysis(@graph_params)
		end
	end

	def get_order_load_analysis(gp)
		@reports = Report.where(restaurant_id: restaurant_id)
		@device_id = gp[:device_id]
		result = []
		to_data = @reports.group("date_trunc('hour', reports.when)").distinct.count(:order_number)
		to_data.each do |h, v|
			logger.debug("#{h} #{v} \n")
			result << {"Hour"=> h.to_s, "Value" => v.to_i}
		end
		result.sort_by{|r| DateTime.parse(r["Hour"])}

	end

	def get_preptime_analysis_data(gp)

		@reports = Report.where(restaurant_id: restaurant_id)
		@device_id = gp[:device_id]
		@order_numbers = @reports.map{|r| r.order_number}.uniq
		result = []
		@order_numbers.each do |onum|
			temphash = {"Order" => onum, "Data" => []}
			to_data = @reports.where(order_number: onum).group("date_trunc('hour', reports.when)").average(:preptime)
			if to_data.length > 1
				to_data.each do |h, v|
					temphash["Data"] << {"Hour" => h.to_s, "Value" => v.to_f}
				end
		
				temphash["Data"] = temphash["Data"].sort_by{|h| DateTime.parse(h["Hour"])}
				result << temphash
			end
		end
		logger.debug(result)
		result
	end

	def graph_title(options)
		"#{options[:graphType]} graph of #{options[:reportType]}"
	end

	def get_x_axis_title(options)
		if options[:graphType] == "Line"
			"Date"
		else
			"Items"
		end
	end

	def get_y_axis_title(options)
		options[:reportType]
	end



	def get_bar_data(options)
		@menu = FoodMenu.where(restaurant_id: restaurant_id).first
		@items = Item.where(foodmenu_id: @menu.id)
		if options[:reportType] == "Prep Time"
			@items.map { |item|
				@preptimes = Report.where(restaurant_id: restaurant_id, item: item.name).map { |report| report.preptime  }
		
				{name: item.name, data: (@preptimes.sum)/(@preptimes.count) }
			 }
		else
			@items.map { |item|
				@frequency = Report.where(restaurant_id: restaurant_id, item: item.name).count
				{name: item.name, data: @frequency}
			 }
		end

	end

	def get_spline_data(options)
		@menu = FoodMenu.where(restaurant_id: restaurant_id).first
		@items = Item.where(foodmenu_id: @menu.id)
		if options[:reportType] == "Prep Time"
			@items.map {|item|
				@reports = Report.where(restaurant_id: restaurant_id, item: item.name)
     			{name: item.name, data: @reports.map { |e| [e.when, e.preptime]  } }
			}
		else
			@items.map { |item|
				@dates_with_count = Report.where(restaurant_id: restaurant_id, item: item.name).group("date(reports.when)").count
				retval = []
				@dates_with_count.map do |key, value|
					retval << [key,value]
				end
				{name: item.name, data: retval}
			}
		end
	end

	def get_highcharts_object
		@graph_params = eval(body)
		LazyHighCharts::HighChart.new('graph') do |f|
			f.title( {:text => graph_title(@graph_params)})
			if @graph_params[:graphType] == "Line"
				f.chart({defaultSeriesType: 'spline'})
				@data = get_spline_data(@graph_params)
			f.xAxis [
				{title: get_x_axis_title(@graph_params), margin: 70},
			]
			f.yAxis [
				{title: get_y_axis_title(@graph_params), margin: 70},
			]
			@data.each do |d|
				f.series(data: d[:data], name: d[:name] )
			end
			else
				@data = get_bar_data(@graph_params)
				f.xAxis [
					{title: get_x_axis_title(@graph_params), margin: 70, categories: @data.map{|e| e[:name]}},
				]
				f.chart({defaultSeriesType: 'column'})
				f.series(data: @data.map{|e| e[:data]})
			end

		
			f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
		end
	end
end
