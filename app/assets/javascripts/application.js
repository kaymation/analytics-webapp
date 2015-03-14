// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require d3
//= require_tree

$(document).ready(function(){
 $("#new_item").submit(function(){
 	 console.log("we are here");
 	var dataSet = $(this).serialize();
 	  $.ajax({
        type: "POST",
        url: 'new_item',
        data: dataSet,
        dataType: 'html',
        success: function(data){

              $('#reftable').html(data);
              console.log($("#reftable"));
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
        	alert("Status: " + textStatus); alert("Error: " + errorThrown); 
    	} 
      });
    return false;
 });


  $("#graph_form").submit(function(){
     console.log("we are here");
     var dataSet = $(this).serialize();
    $.ajax({
            type: "POST",
             url: '/graphs',
             data: dataSet,
               dataType: 'json',
               success: function (data) {
                   draw(data);
               },
               error: function (result) {
                  alert("yafuckedup");
                   error();
               }
           });
   })
 
function draw(data){
  var margin = {
      top: 20,
      right: 80,
      bottom: 60,
      left: 50
  },
  width = 600 - margin.left - margin.right,
      height = 300 - margin.top - margin.bottom;

  var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S UTC").parse;

  var x = d3.time.scale()
      .range([0, width]);

  var y = d3.scale.linear()
      .range([height, 0]);

  var color = d3.scale.category10();

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");

  var line = d3.svg.line()
      .interpolate("basis")
      .x(function (d) {
      return x(d.Hour);
  })
      .y(function (d) {
      return y(d.Value);
  });

  var clear = $("#graphhere").html("");
  var svg = d3.select("#graphhere").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


  if (data[0].Order != null){
    color.domain(data.map(function (d) { return d.Order; }));

    data.forEach(function (kv) {
        kv.Data.forEach(function (d) {
            d.Hour = parseDate(d.Hour);
            console.log(d.Hour)
    });
    });

    var cities = data;

    var minX = d3.min(data, function (kv) { return d3.min(kv.Data, function (d) { return d.Hour; }) });
    var maxX = d3.max(data, function (kv) { return d3.max(kv.Data, function (d) { return d.Hour; }) });
    var minY = d3.min(data, function (kv) { return d3.min(kv.Data, function (d) { return d.Value; }) });
    var maxY = d3.max(data, function (kv) { return d3.max(kv.Data, function (d) { return d.Value; }) });

    x.domain([minX, maxX]);
    y.domain([minY, maxY]);

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Average Preptime(ms)");


    var legendSpace = width/data.length;
    data.forEach(function(d,i){
              svg.append("path")
              .attr("class", "line")
              .attr("fill", "none")
              .style("stroke", function() { // Add the colours dynamically
                  return d.color = color(d.Order); })
              .attr("d", line(d.Data))
              .attr("id", "lineno" + d.Order);



          // Add the Legend
          svg.append("text")                                    // *******
              .attr("x", (legendSpace/2)+i*legendSpace) // spacing // ****
              .attr("y", height + (margin.bottom) - 10)         // *******
              .attr("class", "legend")    // style the legend   // *******
              .style("fill", function() { // dynamic colours    // *******
                  return d.color = color(d.Order); })  
                  .on("click", function(){                     // ************
                  // Determine if current line is visible 
                  var active   = d.active ? false : true,  // ************ 
                  newOpacity = active ? 0 : 1;             // ************
                  // Hide or show the elements based on the ID
                  d3.select("#lineno"+d.Order) // *********
                      .transition().duration(100)          // ************
                      .style("opacity", newOpacity);       // ************
                  // Update whether or not the elements are active
                  d.active = active;                       // ************
                  })             // *******
              .text(d.Order);  
    });
  } else {
    console.log(data)

        data.forEach(function (kv) {
            kv.Hour = parseDate(kv.Hour);
            console.log(kv.Hour + " " + kv.Value)
        });
      var minX = d3.min(data, function (kv) { return d3.min(data, function (d) { return d.Hour; }) });
      var maxX = d3.max(data, function (kv) { return d3.max(data, function (d) { return d.Hour; }) });
      var minY = d3.min(data, function (kv) { return d3.min(data, function (d) { return d.Value; }) });
      var maxY = d3.max(data, function (kv) { return d3.max(data, function (d) { return d.Value; }) });

      x.domain([minX, maxX]);
      y.domain([0, maxY]);

      svg.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")
          .call(xAxis);

      svg.append("g")
          .attr("class", "y axis")
          .call(yAxis)
          .append("text")
          .attr("transform", "rotate(-90)")
          .attr("y", 6)
          .attr("dy", ".71em")
          .style("text-anchor", "end")
          .text("Number of Distinc Order#s");

            svg.append("path")
              .attr("class", "line")
              .attr("fill", "none")
              .style("stroke", "rgb(255, 0, 0)")
              .attr("d", line(data))


  }

}; 
});
