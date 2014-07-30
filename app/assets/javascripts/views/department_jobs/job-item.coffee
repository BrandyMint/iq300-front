class window.JobItem
  constructor: (el)->
    @el = $ el
    @url = @el.data 'url'


app.initializer.addComponent "JobItem", 'department-job-item'