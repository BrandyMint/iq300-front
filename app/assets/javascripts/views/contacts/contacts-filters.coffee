Widget = require 'views/base/widget'

class window.ContactsFilter extends Widget

  bindings: =>
    @folders = $('li.folder', @el)
    @folders.click  @filter
    @expanders = $ '.expander', @el
    @expanders.click @expand
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  expand: (e) =>
    e.preventDefault()
    e.stopPropagation()
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'

  filter: (e) =>
    e.stopPropagation()
    target = $(e.target)
    activeFolder = target.parent().data "folder"
    @folders.removeClass 'active'
    unless activeFolder
      activeFolder = target.data "folder"
      target.addClass "active"
    else
      target.parent().addClass "active"
    if activeFolder
      window.contactsRouter.setParam "folder", activeFolder
    else
      window.contactsRouter.deleteParam "folder"
    window.contactsList.active = false
    window.displayMode.disableMode("view", true)
    window.contactView.clean()
    window.contactsList.setDefaultPage()
    window.contactsList.refresh()
    $('#container').removeClass('show-filters show-list show-navigation')
    false


app.initializer.addComponent "ContactsFilter", "contacts-filter", (obj) =>
  window.contactsFilter = obj
