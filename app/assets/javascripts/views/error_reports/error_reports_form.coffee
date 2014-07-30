class window.ErrorReportForm
  constructor: (el)->
    @$el = $(el)
    @$previousUrlField = $('#error_report_previous_url', @$el)
    @$browserSizeField = $('#error_report_browser_size', @$el)

    @initialize()

  initialize: =>
    @$previousUrlField.val(document.referrer)
    @$browserSizeField.val($(document).width() + 'x' + $(document).height())

app.initializer.addComponent 'ErrorReportForm', 'new_error_report'
