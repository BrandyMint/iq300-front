Widget = require 'views/base/widget'

class window.CalendarView extends Widget

  bindings: =>
    @select = $ "select#community_id", @el
    @select.bind "change", @refresh

  getUrl: =>
    baseUrl = "/calendar?short=true"
    if @select.val() == "-1"
      @url = baseUrl
    else
      @url = "#{baseUrl}&community_id=" + @select.val()
    @url

app.initializer.addComponent "CalendarView"