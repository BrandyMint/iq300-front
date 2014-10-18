$ ->
  scrollableColumn = $('[data-list-with-scroll]')
  if scrollableColumn.length
    projectsListHeader = $('@projects-list-header')
    projectsListFilters =  $('@projects-list-filters')
    projectsListHeaderHeight = projectsListHeader.height()
    projectsListHeaderLeft = scrollableColumn.offset().left
    projectsListHeaderWidth = scrollableColumn.width()
    scrollableColumn.on 'scroll', (e) ->
      if $(@).scrollTop() > projectsListHeaderHeight
        projectsListHeader
          .addClass 'projects-list-header-fixed'
          .css 'left', projectsListHeaderLeft + 'px'
          .css 'width', projectsListHeaderWidth - 1 + 'px'

        projectsListFilters.hide()
      else
        projectsListHeader.removeClass 'projects-list-header-fixed'
        projectsListFilters.show()
    projectsListHeaderFiltersBtn = $('@projects-list-header-filters-btn')
    projectsListHeaderFiltersBtn.on 'click', (e) ->
      e.preventDefault()
      projectsListFilters.toggle()



