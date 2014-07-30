class window.DatePickerEditable
  constructor: (el)->
    @el = $ el
    IQ300.Plugin.use('editable', @initPicker.bind(this))

  initPicker: ->
    IQ300.Plugin.use 'bootstrap-datepicker-ru', =>
      @el.editable
        format: "dd.mm.yyyy"
        viewFormat: "dd.mm.yyyy"
        params:
          editable: true

        datepicker:
          weekStart: 1
          language: 'ru'
        clear: app.i18n.t('components.editable.clear')
        ajaxOptions:
          type: "PUT"
        success: =>

        error: (xhr)=>
          window.errorHandler xhr

app.initializer.addComponent "DatePickerEditable"


