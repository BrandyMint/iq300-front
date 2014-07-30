class DatePeriodTasksFilter
  constructor: (el) ->
    @el = $ el
    @filters = $ '.filter', @el
    @filters.click (ev) =>
      filter = $ ev.currentTarget
      @toggleFilter filter, !filter.hasClass('checked')
    $('input[type="checkbox"], label, i', @el).click (ev) =>
      ev.preventDefault()
      ev.stopPropagation()
      filter = $(ev.currentTarget).parent()
      @toggleFilter filter, !filter.hasClass('checked')

  toggleFilter: (filter, value, setRelated = yes) =>
    if setRelated
      @unselectAll()
      if value && filter.data('select')
        relatedFilters = $ filter.data('select'), @el
        for related in relatedFilters
          @toggleFilter $(related), yes, no
    if value
      filter.addClass 'checked'
    else
      filter.removeClass 'checked'
    checkBox = $ 'input[type="checkbox"]', filter
    setTimeout =>
      checkBox.prop 'checked', filter.hasClass('checked')
    , 0

    @updateList(filter.data('period'), value) if setRelated

  unselectAll: =>
    for filter in @filters
      @toggleFilter $(filter), no, no

  router: =>
    window.tasksRouter

  list: =>
    window.tasksList

  view: =>
    window.taskView

  displayController: =>
    window.displayMode

  updateList: (filterValue, added) =>
    if added
      @router().setParam 'period', filterValue
    else
      @router().deleteParam 'period'

    @displayController().disableMode('view', yes)
    @view().clean()

    @list().active = no
    @list().setDefaultPage()
    @list().refresh()

app.initializer.addComponent DatePeriodTasksFilter,
  className: 'tasks-time-period-filters'
  handler: (obj) =>
    window.datePeriodTasksFilter = obj