Widget = require 'views/base/widget'

class CategoriesTasksFilter extends Widget
  constructor: (el) ->
    @el = $ el
    @categories = $ 'ol li', @el
    @categories.click @filterTasks

  filterTasks: (e) =>
    target = $ e.currentTarget
    checkBox = $ '.checkbox', target

    activeClass = 'active'
    checkedClass = 'checked'
    filterName = 'filters'
    paramName = 'categories'

    target.toggleClass activeClass
    checkBox.toggleClass checkedClass, target.hasClass(activeClass)

    activeCategories = @categories.filter ".#{activeClass}"

    getDataCategory = (obj) ->
      obj.map(-> $(@).data('category')).get().join ','

    if activeCategories.length
      window.tasksRouter.setParam paramName, getDataCategory(activeCategories)
      window.filtersLabel.addFilter filterName, getDataCategory(activeCategories)
    else
      window.tasksRouter.deleteParam paramName
      window.filtersLabel.removeFilter filterName


    window.tasksList.active = no
    window.displayMode.disableMode 'view', yes
    window.tasksList.setDefaultPage()
    window.tasksList.refresh()
    $('#container').removeClass 'show-filters show-list show-navigation'
    no

app.initializer.addComponent CategoriesTasksFilter,
  handler: (obj) =>
    window.categoriesTasksFilter = obj
