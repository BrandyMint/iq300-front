class TasksFilterItem
  constructor: (el) ->
    @el = $ el
    @param = @el.data "param"
    @el.change @onChange

  onChange: =>
    if @el.val()
      window.tasksRouter.setParam @param, @el.val()
    else
      window.tasksRouter.deleteParam @param
    window.tasksList.refresh()

app.initializer.addComponent TasksFilterItem,
  role: "tasks-filter"