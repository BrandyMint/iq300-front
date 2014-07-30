class window.CommunityReportForm
  constructor: (form)->
    @form = $ form
    @results = $ '#community-reports #results'
    @btn = $ 'input[type="submit"]', @form
    @selectBox = $ '#report_report_type', @form
    @dates = $ '.report-period', @form
    @selectBox.change ()=>
      report_type = @selectBox.select2('data').id
      if report_type == ('members_report')
        @dates.fadeOut(0)
      else
        @dates.fadeIn(0)
    @form.submit ()=>
      $.ajax
        type: @form.attr 'method'
        url: @form.attr 'action'
        data: @form.serialize()
        success: (response)=>
          data = $ response
          report = new window.CommunityReport(data)
          @results.html report.el
        beforeSend: =>
          @sending = true
          @form.parent().addClass('is-loading')
        complete: =>
          @sending = false
          @form.parent().removeClass('is-loading')
        error: window.errorHandler
      false

app.initializer.addComponent 'CommunityReportForm', 'report-form'
