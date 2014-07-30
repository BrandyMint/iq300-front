WidgetList = require 'views/base/widget_list'

class window.ActivityList extends WidgetList
  init: =>
    @filters = ["sort", "search"]

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = @router().getParam filter
    @params

  router: =>
    window.activityRouter

app.initializer.addComponent "ActivityList", 'activity-list-column'