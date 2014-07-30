Widget = require 'views/base/widget'

class window.CommunitiesFilter extends Widget
  bindings: =>
    @expanders = $('.expander', @el).on('click', @expand)
    @folders = $('.folder', @el).on('click', @filterByFolder)

    @services = $ 'ol li', @el
    @services.click @filterByServices
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  expand: (e) =>
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'
    counter = target.parent().children('.counter').first()
    counter.toggle()
    counter.hide() if counter.text() == '0'

  filterByFolder: (e) =>
    target = $ e.currentTarget
    activeFolder = target.data "folder"
    @folders.removeClass 'active'
    target.addClass('active')
    if activeFolder
      window.communitiesRouter.setParam("folder", activeFolder)
      window.filtersLabel.addFilter "folder", $.trim(target.children('a').text())
    else
     window.communitiesRouter.deleteParam("folder")
     window.filtersLabel.removeFilter "folder"
    @applyFilter()
    false

  filterByServices: (e) =>
    target = $ e.currentTarget
    target.toggleClass 'active'
    checkBox = $('.checkbox', target)
    if target.hasClass('active')
      checkBox.addClass('checked')
    else
      checkBox.removeClass('checked')
    $activeServices = @services.filter('.active')
    if $activeServices.length
      window.communitiesRouter.setParam('providing_services', $activeServices.map(-> $(@).data('service-id')).get().join(','))
      window.filtersLabel.addFilter 'filters', $activeServices.map(-> $('.label', @).text()).get().join(',')
    else
      window.communitiesRouter.deleteParam('providing_services')
      window.filtersLabel.removeFilter 'filters'
    @applyFilter()
    false

  applyFilter: =>
    window.communitiesList.setDefaultPage()
    window.communitiesList.active = false
    window.communitiesList.refresh()
    $('#container').removeClass('show-filters show-list show-navigation')

app.initializer.addComponent "CommunitiesFilter", "communities-filter", (obj) =>
  window.communitiesFilter = obj
