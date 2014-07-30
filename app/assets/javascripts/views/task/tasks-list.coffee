window.TASK_FOLDER_SCOPES = ['by_status[]', 'tasks', 'folder', 'by_status_not',
                             'by_executor', 'by_customer', 'by_community',
                             'overdue', 'templates', 'favorites_of',
                             'related', 'watchable']

TasksSortedPanel = require "views/task/_tasks-sorted-panel"
WidgetList = require 'views/base/widget_list'

class TasksList extends WidgetList
  init: =>
    @folderScopes = window.TASK_FOLDER_SCOPES
    @filters = ['categories', 'sort', 'search', 'teammate', 'period']
    listHeaderEl = $ "[role='tasks-sorted-panel']", @el
    sortedPanel = new TasksSortedPanel listHeaderEl
    @listHeader = sortedPanel.el

    #TODO ВНИМАНИЕ ДАЛЬШЕ БУДЕТ КОСТЫЛЬ все его методы сделал начинающимися на $
    @groupByFavorites = $ ".favorite-tasks-group", @el
    @groupByFavorites.click @$groupFavorites

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = @router().getParam filter

    for filter in @folderScopes
      @params[filter] = @router().getParam filter
    @params

  clearFolderScopes: =>
    for scope in @folderScopes
      @router.deleteParam scope

  bindings: =>
    super
    @tasks = $ '.task-box', @el
    users = $ ".task-box .user", @el
    #    @tasks.unbind 'click'
    @tasks.click @changeLocation
    users.click @changeLocation

    activeEl = $ '.task-item.active', @el
    @activeLine = activeEl.data 'id' if activeEl

    favorites = $ "[role='favorite-list-view']", @el
    for favoriteEl in favorites
      new window.FavoriteListItem(favoriteEl)



  $groupFavorites: =>
    if @favoritesGrouped
      @groupByFavorites.css "font-weight", "normal"
      @favoritesGrouped = false
      @refresh()
      return
    @favoritesGrouped = true
    @groupByFavorites.css "font-weight", "bold"
    @$removeGroupTitles()
    list = $ ".infinite-list", @el
    
    task_list = $ ".task-box", @el
    defaultTaskList = task_list.filter(":not(.is-favorite)")
    favoriteTaskList = task_list.filter(".is-favorite")

    favoritesTitle = @$addGroupTitle "Важные"
    defaultTitle = @$addGroupTitle "Не важные"

    if defaultTaskList.length > 0
      defaultTitle.prependTo list

      for defaultTask in defaultTaskList
        $(defaultTask).insertAfter defaultTitle
      no

    if favoriteTaskList.length > 0
      favoritesTitle.prependTo list

      for favoriteTask in favoriteTaskList
        $(favoriteTask).insertAfter favoritesTitle
      no

  $addGroupTitle: (label)=>
    $("<h4></h4>").addClass("task-group-title").html label

  $removeGroupTitles: =>
    $("h4.task-group-title", @el).remove()


  getParamsStr: =>
    str=''
    for key, value of @getParams()
      if value != undefined && key != undefined
        str += "#{key}=#{value}&"
    str

  router: =>
    window.tasksRouter

  changeLocation: (ev)=>
    target = $ ev.currentTarget
    url = target.data "href"
    window.location = url
    return no

  showTask: (ev) =>
    if target.hasClass 'active'
      target.removeClass 'active'
      window.displayMode.disableMode 'view'
      return no
    @clearSelection()
    target.addClass 'active'
    @activeLine = target.data 'id'
    communityId = target.data 'community-id'
    url = "tasks/#{@activeLine}?#{@getParamsStr()}"
    if communityId
      url = "communities/#{communityId}/#{url}"
    folder = @router().getParam('folder')
    searchInput = $ '#search', '.search'
    searchInput.val('') if searchInput
    @router().navigate url, yes
    window.displayMode.enableMode('view')
    no

  clearSelection: =>
    @tasks.removeClass 'active'

app.initializer.addComponent TasksList,
  className: 'tasks-list-column'
  handler: (obj) =>
    window.tasksList = obj
