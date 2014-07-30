Widget = require 'views/base/widget'

class CategoriesErrorReportsFilter extends Widget
  constructor: (el) ->
    @el = $ el
    @categories = $ 'ol li', @el
    @categories.click @filterErrorReports

  filterErrorReports: (e) =>
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
      window.appRouter.setParam paramName, getDataCategory(activeCategories)
      window.filtersLabel.addFilter filterName, getDataCategory(activeCategories)
    else
      window.appRouter.deleteParam paramName
      window.filtersLabel.removeFilter filterName


    window.errorReportsList.active = no
    window.displayMode.disableMode 'view', yes
    window.errorReportView.clean()
    window.errorReportsList.setDefaultPage()
    window.errorReportsList.refresh()
    $('#container').removeClass 'show-filters show-list show-navigation'
    no

app.initializer.addComponent CategoriesErrorReportsFilter,
  handler: (obj) =>
    window.categoriesErrorReportsFilter = obj
