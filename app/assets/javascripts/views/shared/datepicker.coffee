class window.DatePicker
  constructor: (el)->
    @el = $ el
    #    linkField = @el.data 'target'
    expand = @el.data 'expand-on-change'
    dateFormat = @el.data("format") || "dd.mm.yyyy hh:ii"
    window.IQ300.Plugin.use "bootstrap-datepicker", =>
      window.IQ300.Plugin.use "bootstrap-datepicker-ru", =>
        window.datepicker = @datepicker = @el.datepicker
          format: dateFormat
    #      linkFormat: dateFormat
    #      showMeridian: true
          autoclose: true
          language: "ru"
          todayBtn: true
          weekStart: 1
    #      linkField: linkField

    if expand
      @datepicker.on 'changeDate', ()->
        $('#'+expand).addClass 'expanded' #TODO зачем?
  show: =>
    @el.datepicker "show"

  hide: =>
    @el.datepicker "remove"

app.initializer.addComponent "DatePicker", "open-datepicker"