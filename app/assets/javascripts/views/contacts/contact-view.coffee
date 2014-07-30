Widget = require 'views/base/widget'

class window.ContactView extends Widget

  constructor: (el) ->
    @el = $(el)

  show: (id) =>
    @id = id
    @refresh()

  getUrl: =>
    @url = "/contacts/#{@id}"
    @url

  bindings: =>
    window.displayMode.bindings()

app.initializer.addComponent 'ContactView', 'contacts-view-column', (obj) ->
  window.contactView = obj
