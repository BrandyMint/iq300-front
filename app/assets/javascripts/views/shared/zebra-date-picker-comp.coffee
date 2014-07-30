class window.ZebraDatepickerComp
  DEFAUL_LOCALE: 'ru'
  config:
    calendarBtnSelector: '.input-group-addon'

  constructor: (el)->
    @el = $ el
    IQ300.Plugin.use 'zebra-datepicker', @initDatepicker

  initDatepicker: =>
    directionStart = @el.data("direction-start") || false
    directionEnd = @el.data("direction-end") || false
    defaults =
      direction: [directionStart, directionEnd]
      show_icon: false
      onSelect: =>
        @el.trigger 'change'

    ruDefaults =
      days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
      daysShort: ["Вск", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"]
      days: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
      months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
      monthsInput: ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]
      monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
      show_select_today: "Сегодня"
      lang_clear_date: "Очистить"

    if @getCurrentLocale() == 'ru'
      defaults = _.extend(defaults, ruDefaults)

    @el.Zebra_DatePicker(defaults)

    @el.siblings(@config.calendarBtnSelector).click =>
      @el.click()




  getCurrentLocale: =>
    $.cookie 'locale' || @DEFAUL_LOCALE

app.initializer.addComponent 'ZebraDatepickerComp', 'zebra-date-picker'