Widget = require 'views/base/widget'

class window.DocumentsFilter extends Widget
  bindings: =>
    @expanders = $ '.expander', @el
    @folders = $ ".folder", @el
    @expanders.click @expand
    @folders.click @filterDocuments
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  isActive: =>
    false

  expand: (e) =>
    e.preventDefault()
    e.stopPropagation()
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'
    counter = target.parent().children('.counter').first()
    counter.toggle()
    counter.hide() if counter.text() == '0'

  router: =>
    window.documentsRouter

  list: =>
    window.documentsList

  view: =>
    window.documentView

  filterDocuments: (e) =>
    target = $ e.currentTarget
    activeFolder = target.data "folder"
    activeCommunity= target.data "community"
    @folders.removeClass 'active'
    target.addClass('active')
    if activeFolder
      @router().setParam "folder", activeFolder
    else
      @router().deleteParam "folder"
    if activeCommunity
      @router().setParam "community", activeCommunity
      $(window).trigger 'docs-community-changed', [activeCommunity]
    else
      @router().deleteParam "community"
      $(window).trigger 'docs-community-changed'
      @list().active = false
    window.displayMode.disableMode("view", true)
    window.displayMode.enableMode("list", true)
    @view().clean() if @view()
    @list().setDefaultPage()
    @list().refresh()
    $('#container').removeClass('show-filters show-list show-navigation')
    false

app.initializer.addComponent "DocumentsFilter", "documents-filter", (obj) =>
  window.documentsFilter = obj

