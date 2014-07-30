Widget = require 'views/base/widget'

class window.JobsList extends Widget
  bindings: =>
    super
    @jobs = $("li.department-job-item", @el)
    @form = $ 'form', @el
    @form.submit @formSubmit

  formSubmit: (e)=>
    @data = @form.serialize()
    @el.addClass 'is-loading'
    $.ajax
      type: 'post',
      url: @form.attr('action'),
      data: @data
      success: (data, status, xhr) =>
        html = $ data
        @el.html html
        app.initializer.initialize @el
        @el.removeClass 'is-loading'
        @bindings()

    e.preventDefault()


app.initializer.addComponent "JobsList", "jobs-list-column", (obj) ->
  window.jobsList = obj