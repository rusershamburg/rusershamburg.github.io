/**
* plot time series
* 
* @param {string} element_id 
* @param {url string} data_source 
* 
* @author peter meissner
*/
var ts_plot = function (
  element_id,
  data_source,
  time_column,
  ts_columns,
  title
) {
  $(window).resize(
    function () {
      ts_plot_event_handler(
        element_id  = element_id,
        data_source = data_source,
        time_column = time_column,
        ts_columns  = ts_columns,
        title       = title
      );
    }
  )
}
