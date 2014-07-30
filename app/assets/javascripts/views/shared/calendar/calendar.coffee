class window.EventsCalendar
  DEFAUL_LOCALE: 'ru'

  constructor: (el)->
    @el = $ el
    @initCalendar()

  initCalendar: =>
    @dayContainer = @el.parent().find('.about-day')
    IQ300.Plugin.use 'moment', =>
      IQ300.Plugin.use 'fullcalendar', =>
        @el.fullCalendar
          header:
            left: 'title'
            right: 'prev,next today'
          lang: @getCurrentLocale()
          editable: false
          events: @getTasks #gon.calendar_tasks
          selectable: true
          select: @selectDay
          unselect: @unselectDay
          timeFormat: ''
          eventMouseover: @eventMouseover
        setTimeout =>
          @el.fullCalendar( 'today' )
        , 0

  getCurrentLocale: =>
    $.cookie 'locale' || @DEFAUL_LOCALE

  getTasks: (start, end, timezone, callback)=>
    $.ajax
      url: @getUrl()
      dataType: "json"
      data:
        start: Math.round(start.valueOf()/1000)
        end: Math.round(end.valueOf()/1000)
      beforeSend: =>
        @el.addClass 'is-loading'
      complete: =>
        @el.removeClass 'is-loading'
      success: (data) =>
        events = []
        for task in data['tasks']
          events.push task
        callback events


  eventMouseover: (event, jsEvent, view)=>
    target = $ jsEvent.currentTarget
    target.prop 'title', event.title unless target.prop('title')


  selectDay: (startDate, endDate, allDay, jsEvent, view)=>
    url = @getUrlForDates startDate, endDate
    $.ajax
      type: "GET"
      url: url
      beforeSend: @clearDayContainer
      success: @updateDayContainer

  getUrl: =>
    @el.data('tasks-url')

  getUrlForDates: (startDate, endDate)=>
    baseUrl = @getUrl()
    str = if baseUrl.indexOf('?') == -1
            '?'
          else
            '&'
    "#{baseUrl}#{str}start_date=#{startDate}&end_date=#{endDate}"


  clearDayContainer: =>
    @dayContainer.addClass('is-loading')

  updateDayContainer: (data)=>
    @dayContainer.removeClass('is-loading')
    @dayContainer.html(data)

#  unselectDay: =>

app.initializer.addComponent "EventsCalendar"
