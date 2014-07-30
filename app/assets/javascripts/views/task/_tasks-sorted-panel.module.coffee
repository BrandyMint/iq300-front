ID = 0
class TaskSortedItem
  constructor: (el) ->
    @id = (ID += 1)
    @el = $ el
    @el.click @toggle
    @column = @el.data "column"
    @icon = $ ".fa", @el
    @reset()

  toggle: =>
    sortParam = "#{if @reverseDirection() is "desc" then "-" else ""}#{@column}"
    @updateView()
    @onSort? sortParam
    false

  reverseDirection: =>
    @direction = if @direction is "asc" then "desc" else "asc"

  updateView: => @icon.show().attr "class", "fa fa-sort-amount-#{@direction}"

  reset: =>
    @direction = @el.data "direction"
    @icon.hide()


class TasksSortedPanel
  constructor: (el)->
    @el = $ el
    @links = $ "[data-direction]", @el
    @views = for linkEl in @links
      sortedItem = new TaskSortedItem linkEl
      globalSort = @onSort
      sortedItem.onSort = (sortParam) -> globalSort(@, sortParam)
      sortedItem

  onSort: (target, sortParam) =>
    for view in @views
      view.reset() unless view is target
    @el.trigger("sort", [sortParam])

module.exports = TasksSortedPanel