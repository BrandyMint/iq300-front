class window.BestInPlaceComp
  constructor: (el)->
    @el = $ el
    @el.best_in_place()
    if @el.data("type") == "date"
      IQ300.Plugin.use 'zebra-datepicker', =>
        (($) ->
          $.fn.datepicker = (options)->
            oldValue =  @.val()
            time = @.val().substr(10, 15)
            @.val(@.val().substr(0, 10))
            datepicker = @.data "Zebra_DatePicker"

            if typeof options is "string"
              funcStr = options
              options = {}

            if options && options.onClose
              parent = @.parents '.best_in_place'
              onCloseFunc = options.onClose
              skipTime = parent.data("skip-time") || false
              options.onClose = (element)=>
                value = element.val()
                newValue = value + time
                if value.length == 10 && !skipTime
                  element.val newValue
                if newValue == oldValue
                  parent.data("bestInPlaceEditor").abort()
                else
                  onCloseFunc()

              directionStart = parent.data("direction-start") || false
              directionEnd = parent.data("direction-end") || false
              options.direction = [directionStart, directionEnd]
              options.show_select_today = false
              options.format = "Y-m-d"
              options.show_clear_date = false
              options.show_icon = false
              ruDefaults =
                days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
                daysShort: ["Вск", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"]
                days: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
                monthsInput: ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]
                monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
                show_select_today: "Сегодня"
                lang_clear_date: "Очистить"

              options = _.extend(options, ruDefaults)

            unless datepicker
              datepicker = @.Zebra_DatePicker options
            if funcStr
              eval "datepicker.#{funcStr}()"
            else
              datepicker
        ) jQuery

app.initializer.addComponent 'BestInPlaceComp', 'best_in_place'