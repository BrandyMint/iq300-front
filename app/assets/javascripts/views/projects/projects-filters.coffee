Widget = require 'views/base/widget'

class window.ProjectsFilter extends Widget
  ALLOWED_FILTERS: ['folder', 'categories', 'sort', 'search', 'community_id']

  init: =>
    @expanders = $ '.expander', @el
    @folders = $ '.folder', @el
    @communitySelect = $ '.top-panel #community_id'
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  bindings: =>
    @expanders.on 'click', @expand
    @folders.on 'click', @filterWithFolder
    @communitySelect.on 'change', @filterWithCommunity

  isActive: =>
    false

  expand: (event) =>
    event.preventDefault()
    event.stopPropagation()
    targetParent = $(event.currentTarget).parent()
    targetParent.toggleClass 'expanded'
    counter = targetParent.children('.counter').first()
    counter.toggle()
    counter.hide() if counter.text() == ''

  filterWithFolder: (event)=>
    event.preventDefault()
    event.stopPropagation()
    activatedFolder = $ event.currentTarget
    folder = activatedFolder.data 'folder'
    @folders.removeClass 'active'
    activatedFolder.addClass 'active'
    @filterProjects 'folder', folder

  filterWithCommunity: (event)=>
    event.preventDefault()
    val = @communitySelect.val()
    @filterProjects 'community_id', val

  filterProjects: (key, value)->
    if value
      window.projectsRouter.setParam key, value
    else
      window.projectsRouter.deleteParam key

    window.projectsList.active = false
    window.displayMode.enableMode('list', projectsRouter)
    window.displayMode.disableMode('view', true, projectsRouter)
    window.projectsView.clean()
    window.projectsList.setDefaultPage()
    window.projectsList.refresh()
    $('#container').removeClass('show-filters show-list show-navigation')

app.initializer.addComponent 'ProjectsFilter', 'projects-filter'
