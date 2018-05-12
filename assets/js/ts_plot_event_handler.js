
/**
* plot time series (event hadler part)
* 
* @param {string} element_id 
* @param {url string} data_source 
* 
* @author peter meissner
*/
ts_plot_event_handler = function (
  element_id,
  data_source,
  time_column,
  ts_columns,
  title
) {

  // pre process inputs 
  if (!Array.isArray(ts_columns)) {
    var ts_columns = [ts_columns]
  }

  var element_id = "#" + element_id;



  // set the dimensions and margins of the graph
  if ($(element_id).width() > 400) {
    var width = 400;
  } else {
    var width = $(element_id).width();
  }
  var margin = { top: 20, right: 40, bottom: 30, left: 40 }
  var width = width - margin.left - margin.right;
  var height = $(element_id).height() - margin.top - margin.bottom;

  // parse/format the date / time
  var parseTime  = d3.timeParse("%Y-%m-%d");
  var formatTime = d3.timeFormat("%Y-%m-%d");

  // set the ranges
  var x = d3.scaleTime().range([0, width]);
  var y = d3.scaleLinear().range([height, 0]);

  // define the line
  var valueline = d3.line()
    .x(function (d) { return x(d[time_column]); })
    .y(function (d) { return y(d[ts_columns]); });


  // clear chart
  d3.select(element_id).selectAll("*").remove();

  // append the svg obgect to the body of the page
  var svg = d3.select(element_id).append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    //.attr("style", "border: 1px solid lightsteelblue;")
    .append("g")
    .attr("transform",
      "translate(" + margin.left + "," + margin.top + ")");

  // Get the data
  d3.csv(
    data_source,
    function (error, data) {
      if (error) throw error;


      // format the data
      data.forEach(function (d) {
        d[time_column] = parseTime(d[time_column]);
        for (let ts_col = 0; ts_col < ts_columns.length; ts_col++) {
          d[ts_columns[ts_col]] = parseFloat(d[ts_columns[ts_col]]);
        }
      });

      // Scale the range of the data
      x.domain(
        d3.extent(data, function (d) { return d[time_column]; })
      );

      var min = d3.min(data, function (d) { return d[ts_columns]; });
      var max = d3.max(data, function (d) { return d[ts_columns]; });
      y.domain(
        //data.map(item => item.count)
        [
          (0) - Math.abs(max - min) * 0.1,
          (max) + Math.abs(max - min) * 0.1
        ]
      );

      // Add the X Axis
      svg.append("g")
        .attr("class", "plot_second")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x).tickSize(0).ticks(5));

      svg.append("g")
        .attr("class", "plot_second xaxis")
        .call(d3.axisBottom(x).ticks(0).tickSize(0));

      // Add the Y Axis
      svg.append("g")
        .attr("class", "plot_second")
        .call(d3.axisLeft(y).tickValues([min]).tickSize(0));

      svg.append("g")
        .attr("class", "plot_second")
        .attr("transform", "translate(" + width + ",0)")
        .call(d3.axisRight(y).tickValues([max]).tickSize(0));

      // Add the valueline path.
      svg.append("path")
        .data([data])
        .attr("class", "plot_first")
        .attr("d", valueline);

      // add title 
      svg.append("g")
        .attr("class", "plot_second")
        .append("text")
        .attr("x", (width / 2))
        .attr("y", 0 - (margin.top / 4))
        .attr("text-anchor", "middle")
        .attr("style", "font-family: sans-serif;")
        .text(title);

      // tooltip
      var div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);
      
      svg.selectAll("dot")
        .data(data)
        .enter().append("circle")
        .attr("class", "plot_pseudo")
        .attr("r", 8)
        .attr("cx", function (d) { return x(d[time_column]); })
        .attr("cy", function (d) { return y(d[ts_columns[0]]); })
        .on("mouseover", function (d) {
          div.transition()
            .duration(200)
            .style("opacity", 0.9);
          div.html(d[ts_columns[0]] + "<br/>" + formatTime(d[time_column]))
            .style("left", (d3.event.pageX + 15) + "px")
            .style("top", (d3.event.pageY + 15) + "px");
        })
        .on("mouseout", function (d) {
          div.transition()
            .duration(500)
            .style("opacity", 0);
        });


    });
}

