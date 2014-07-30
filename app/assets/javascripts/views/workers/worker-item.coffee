class window.WorkerItem
  constructor: (el)->
    @el = $ el
    @url = @el.data 'url'


app.initializer.addComponent "WorkerItem", 'worker-job-item'