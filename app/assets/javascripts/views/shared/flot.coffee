class window.Flot
  constructor: (el)->
    @el = $ el
    @chart_data = @el.data('chart')
    @tick = @el.data('tick')
    @el.plot(
      [@chart_data]
#      points:
#        show: true
      lines:
        show: true
      yaxis:
        min: 0
        axisLabel: 'Количество'
        tickDecimals: 0
        tickFormatter: (v) ->
          return v + " шт";
      xaxis:
        axisLabel: 'Время'
        mode: "time"
        timezone: "browser"
        tickSize: @tick
#        min: (new Date(2012, 11, 1)).getTime()
#        max: (new Date(2013, 11, 1, )).getTime()
        timeFormat: '%m %Y'
    )



app.initializer.addComponent 'Flot', 'flot-chart'
