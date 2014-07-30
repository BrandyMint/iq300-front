class window.FiltersLabel
  constructor: ->
    @filters = {folder:'', filters:''}
    @container = $('.top-panel .filters-list strong')

  addFilter: (ftitle, filters)=>
    @filters[ftitle] = filters
    @refreshContainerData()

  removeFilter: (ftitle)=>
    @filters[ftitle] = ''
    @refreshContainerData()

  refreshContainerData: =>
    text = @filters.folder
    if @filters.folder.length > 0 && @filters.filters.length > 0
      text += ','
    text += @filters.filters
    @container.text(text)


$ ->
  window.filtersLabel = new window.FiltersLabel

