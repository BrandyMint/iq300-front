Widget = require 'views/base/widget'

class window.WorkersList extends Widget
  bindings: =>
    super
    @jobs = $("li.worker-item", @el)
    @searchForm = $ '.search-worker-for-community', @el
    @searchForm.on 'ajax:success', '.best_in_place', @refreshWorkers

  refreshWorkers: =>
    @el.addClass 'is-loading'
    @refresh()
    @el.removeClass 'is-loading'

app.initializer.addComponent "WorkersList", "workers-list-column", (obj) ->
  window.workersList = obj