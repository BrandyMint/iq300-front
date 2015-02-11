window.Calendar ||= {}

((app) ->
  $calendar = $('@fullcalendar')
  $calendar.fullCalendar
    dayClick: ->
      alert('a day has been clicked!')

)(window.Calendar ||={} )
