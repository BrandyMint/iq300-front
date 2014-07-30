class window.SortedColumnTitle
  constructor: (el)->
    @el = $ el
    @links = $ "a", @el
    @sortableCollection = @el.data "sortable-collection"
    if @el.data("store") == 1
      @restoreFromCookie()
    @links.click @sortList

  sortList: (ev)=>
    target = $ ev.currentTarget
    column = target.data "column"
    direction = @getOppositeDirection(target.data "direction")
    target.data "direction", direction
    sortParam = "#{direction}#{column}"
    @el.trigger("sort", [sortParam])
    @setSortDirection(column, direction)
    false

  getOppositeDirection: (direction)=>
    if direction == "" || direction == undefined
      return "-"
    else
      return ""

  restoreFromCookie: =>
    column = $.cookie @sortableCollection + "_sort_column"
    direction = $.cookie @sortableCollection + "_sort_direction"
    @setSortDirection(column, direction)

  setSortDirection: (column, direction) =>
    if column
      if direction is ""
        arrow = "<span class='sort-arrow'>↓</span>"
      else
        arrow = "<span class='sort-arrow'>↑</span>"
      columnEl = @links.filter "[data-column='#{column}']"
      @links.removeClass "sorted-"
      @links.removeClass "sorted"
      for link in @links
        link = $ link
        rowPos = link.find('.sort-arrow')
        if rowPos.length > 0
          rowPos.remove()
      if columnEl.length > 0
        columnEl.append arrow
        sortedClass = "sorted" + direction
        unless columnEl.hasClass sortedClass
          columnEl.addClass sortedClass


app.initializer.addComponent "SortedColumnTitle", "sortable-header"