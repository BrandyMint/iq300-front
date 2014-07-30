WidgetList = require 'views/base/widget_list'

class window.ProjectsList extends WidgetList
  ACTIVE_CLASS: 'active'
  ITEM_CLASS: 'project-item'
  ALLOWED_FILTERS: ['folder', 'categories', 'sort', 'search', 'community_id', 'teammate']

  init: =>
    @activatedProject = $ ".#{@ITEM_CLASS}.#{@ACTIVE_CLASS}", @el

  bindings: =>
    super
    @projects = $ ".#{@ITEM_CLASS}", @el
    @projects.unbind "click"
    @projects.click @showProject

  router: ->
    window.projectsRouter

  projectView: ->
    window.projectsView

  getParams: =>
    @params = @params || {}
    for filter in @ALLOWED_FILTERS
      @params[filter] = @router().getParam filter
    @params

  getParamsStr: =>
    queries = []
    params = @getParams()
    str = if _.any(params) then '?' else ''
    for key, value of params
      queries.push("#{key}=#{value}") if value != undefined and key != undefined
    str += queries.join('&')

  animatedContainer: =>
    @getInfiniteList()

  clearSelection: =>
    @activatedProject.removeClass(@ACTIVE_CLASS) if @activatedProject
    @activatedProject = null

  showProject: (event)=>
    event.preventDefault()
    target = $ event.currentTarget

    if target.hasClass(@ACTIVE_CLASS)
      target.removeClass @ACTIVE_CLASS
      @clearSelection()
      window.displayMode.disableMode 'view', @router()
      return false

    @clearSelection()
    @activatedProject = target
    @activatedProject.addClass @ACTIVE_CLASS
    url = @activatedProject.attr('href') + @getParamsStr()
    @router().navigate url, false
    @projectView().show(target.data('id'))
    window.displayMode.enableMode 'view', @router()

app.initializer.addComponent 'ProjectsList', 'projects-list-column', (obj)=>
  window.projectsList = obj