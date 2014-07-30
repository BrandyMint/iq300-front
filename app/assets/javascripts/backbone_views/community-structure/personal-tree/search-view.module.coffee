SearchFilter = require "models/filters/search-filter"
View = require "backbone_views/base/view"

class SearchView extends View
  template: "personal-tree/search"

  collection: ->
    window.workers.models

  domBindings: =>
    super
    @input = @$ "input"
    @btn = @$ ".icon-search"
    @btn.click @search
    @$el.bind "expanded", @setFocus
    @input.keypress (e)=>
#      code = if e.keyCode then e.keyCode else e.which
#      @search() #if code is 13
      @search() # if @input.val().length >= 2

  search: =>
    @model = new SearchFilter unless @model
    @model.set "str", @input.val()
    @trigger "searching", @model.use(@collection())

  setFocus: =>
    @input.focus() if @$el.hasClass "search-expanded"

module.exports = SearchView