window.Calendar ||= {}

((app) ->
  $(document).ready ->
    $calendar = $('@fullcalendar')
    jsonUrl = $calendar.data('events')
    multiselectUsers = $('@multiselect-calendar-users')
    multiselectCommunities = $('@multiselect-calendar-communities')

    $calendar.fullCalendar
      eventRender: (event, element) ->
        if event.type == "deadline"
          element.addClass "fullcalendar-event-type-deadline"

      dayClick: ->
        if $(@).data('bs.popover')?.$tip?.length > 0
          $calendar.find('td').each ->
            $(@).popover('destroy')
        else
          $calendar.find('td').each ->
            $(@).popover('destroy')
          app.pop = app.popover $(@)
          $popover = app.pop.data('bs.popover')
          app.pop.popover('show')
          $popover.$tip.find('[role="event-participants"]').select2
            width: "100%"
          $popover.$tip.find('input[type="datetime"]').datetimepicker
            keepOpen: false
            language: 'ru'
            icons:
              time: "fa fa-clock-o datetimepicker-icon",
              date: "fa fa-calendar datetimepicker-icon",
              up: "fa fa-arrow-up datetimepicker-icon",
              down: "fa fa-arrow-down datetimepicker-icon"
            format: 'DD/MM/YYYY HH:mm'
          $popover.$tip.find('input:first').focus()

      header:
        left: 'prev,next today'
        center: 'title, users, communities'
        right: 'month,agendaWeek,agendaDay'
      defaultDate: '2015-02-12'
      editable: true
      #eventLimit: true, // allow "more" link when too many events
      events:
        url: jsonUrl
        error: ->
          console.log 'calendar events error'
      #loading: (bool) ->
        #$('@fullcalendar-loading').toggle(bool)

    multiselectUsers.multiselect
      maxHeight: 200
      includeSelectAllOption: true
      enableFiltering: true
      enableCaseInsensitiveFiltering: true
      selectAllText: 'Все участники'
      buttonText: (options, select) ->
        if multiselectUsers.find('option:selected').length is 0 || multiselectUsers.find('option:selected').length is multiselectUsers.find('option').length
          "<i class=\"fa fa-user\"></i>&nbsp; Все участники <b class=\"caret\"></b>"
          #else if options.length is 0
          #"<i class=\"fa fa-user\"></i> Все"
        else
          "<i class=\"fa fa-user\"></i>&nbsp; Участники: " + options.length + " <b class=\"caret\"></b>"

    multiselectCommunities.multiselect
      maxHeight: 200
      includeSelectAllOption: true
      enableFiltering: true
      enableCaseInsensitiveFiltering: true
      selectAllText: 'Все сообщества'
      buttonText: (options, select) ->
        if multiselectUsers.find('option:selected').length is 0 || multiselectUsers.find('option:selected').length is multiselectUsers.find('option').length
          "<i class=\"fa fa-users\"></i>&nbsp; Все сообщества <b class=\"caret\"></b>"
          #else if options.length is 0
          #"<i class=\"fa fa-user\"></i> Все"
        else
          "<i class=\"fa fa-users\"></i>&nbsp; Сообщества: " + options.length + " <b class=\"caret\"></b>"



  app.popover = (el) ->
    pop = $(el).popover
      template: '<div class="fullcalendar-event-popover" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        </div>'
      content: '<form class="form form-vertical fullcalendar-event-form">
          <input class="fullcalendar-event-form-control fullcalendar-event-form-control-title" type="text" placeholder="Новое событие">
          <div class="checkbox">
            <label>
              <input type="checkbox">
              Весь день
            </label>
          </div>
          <input class="fullcalendar-event-form-control" type="datetime" placeholder="Начало события">
          <input class="fullcalendar-event-form-control" type="datetime" placeholder="Конец события">
          <div class="fullcalendar-event-form-actions">
            <select class="" data-placeholder="Участники" role="event-participants" multiple="">
              <option>А. Мещеряков</option>
              <option>Э. Нуриахметов</option>
              <option>Ш. Хамадеев</option>
          </select>
        </div>
        <div class="fullcalendar-event-form-actions">
          <a href="" class="fullcalendar-event-form-submit-btn">Сохранить</button>
        </form-group>
        </form>'
      html: true
      placement: 'right'
      trigger: 'manual'
      container: '[role="calendar-container"]'
    return pop


)(window.Calendar ||={} )