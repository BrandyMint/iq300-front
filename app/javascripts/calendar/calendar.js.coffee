window.Calendar ||= {}

((app) ->
  $(document).ready ->
    $calendar = $('@fullcalendar')
    jsonUrl = $calendar.data('events')
    eventModalEl = $('@calendar-block-modal')
    app.calendar = $calendar.fullCalendar
      eventRender: (event, element) ->
        if event.type == "deadline"
          element.addClass "fullcalendar-event-type-deadline"

      dayClick: =>
        app.eventModal = $(eventModalEl).modal()
        $eventModal = app.eventModal.data('bs.modal')
        eventBindings app.eventModal
      header:
        left: 'prev,next today'
        center: 'title, users, communities'
        right: 'month,agendaWeek,agendaDay'
      defaultDate: '2015-12-12'
      editable: true
      #eventLimit: true, // allow "more" link when too many events
      events:
        url: jsonUrl
        error: ->
          console.log 'calendar events error'
      #loading: (bool) ->
        #$('@fullcalendar-loading').toggle(bool)

  app.popover = (el) ->
    pop = $(el).popover
      template: '<div class="fullcalendar-event-popover" role="tooltip">
        <div class="arrow"></div>
        <a class="popover-close-btn">&times;</a>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        </div>'
      content: '<form class="form form-vertical fullcalendar-event-form">
          <div class="fullcalendar-event-form-text fullcalendar-event-form-control-title" type="text">
            Новая версия календаря
          </div>
          <div class="fullcalendar-event-form-text">
            <a href="/tasks/show/">
              http://app.iq300.ru/tasks/4765
            </a>
          </div>
          <div class="fullcalendar-event-form-text">
            Описание встречи
          </div>
          <div class="fullcalendar-event-form-text">
           Сообщество IQ300
          </div>
          <div class="checkbox">
            <label>
              <input type="checkbox">
              Весь день
            </label>
          </div>
          <div class="fullcalendar-event-form-text">
            4 февраля с 11:00 до 13:00
          </div>
          <div class="fullcalendar-event-form-text">
            А. Мещеряков,
            Э. Нуриахметов
            Ш. Хамадеев
          </div>
          <div class="fullcalendar-event-form-actions">
            <a href="javascript:confirm(\'Точно удалить событие?\');" class="btn btn-sm btn-link-danger pull-left">Удалить</a>
            <a href="" class="fullcalendar-event-form-submit-btn pull-right" role="event-edit">Изменить</a>
            <div class="clearfix"></div>
          </div>
          </form>'
      html: true
      placement: 'right'
      trigger: 'manual'
      container: '[role="calendar-container"]'
    return pop


  app.popoverEdit = (el) ->
    pop = $(el).popover
      template: '<div class="fullcalendar-event-popover" role="tooltip">
        <div class="arrow"></div>
        <a class="popover-close-btn">&times;</a>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        </div>'
      content: '<form class="form form-vertical fullcalendar-event-form">
          <input class="fullcalendar-event-form-control fullcalendar-event-form-control-title" type="text" placeholder="Новое событие">
          <textarea class="fullcalendar-event-form-control" role="autosize" placeholder="Добавить описание"></textarea>
          <div class="fullcalendar-event-form-actions">
            <select class="" data-placeholder="Выберите календарь" role="select2">
              <option selected="selected">Выберите календарь</option>
              <option>Test community</option>
              <option>IQ300</option>
          </select>
          </div>
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
            <a href="javascript:confirm(\'Точно удалить событие?\');" class="btn btn-sm btn-link-danger pull-left">Удалить</a>
            <a href="" class="fullcalendar-event-form-submit-btn pull-right">Сохранить</a>
            <div class="clearfix"></div>
          </div>
          </form>'
      html: true
      placement: 'auto'
      trigger: 'manual'
      container: '[role="application-content-block"]'
    return pop

  eventBindings = ($el) ->
    $el.find('[role="event-participants"], [role="select2"]').select2
      width: "100%"
    $el.find('input[type="datetime"]').datetimepicker
      keepOpen: false
      showClose: true
      #language: 'ru'
      icons:
        time: "fa fa-clock-o datetimepicker-icon",
        date: "fa fa-calendar datetimepicker-icon",
        up: "fa fa-arrow-up datetimepicker-icon",
        down: "fa fa-arrow-down datetimepicker-icon"
        clear: 'fa fa-trash-o'
        close: 'fa fa-times'
        today: 'fa fa-crosshairs'
      format: 'DD/MM/YYYY HH:mm'
    $el.find('input:first').focus()
    $el.find('[role*="autosize"]').autosize()


)(window.Calendar ||={} )
