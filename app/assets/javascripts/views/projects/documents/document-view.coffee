Widget = require 'views/base/widget'

class window.ProjectDocumentView extends Widget
  show: (id)=>
    @id = id
    @empty = false
    @active = false
    @refresh()

  doAction: (e) =>
    target = $ e.currentTarget
    url = target.prop("href")
    @active = false
    $.ajax
      url: url
      data: @params
      type: "PUT"
      success: @draw
      error: window.errorHandler
    false

  refresh: =>
    $.ajax
      url: @getUrl()
      data: @params
      type: "GET"
      success: @draw
      error: window.errorHandler

  getUrl: =>
    regexp = /\/\d*$/
    if  @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"  if @id
    @url

  bindings: =>
    @allDocsLink = $ ".all-documents a", @el
    @allDocsLink.click @showDocsList
    @activateBindings()

  showDocsList: (ev) =>
    window.projectDocsRouter.navigate window.projectDocumentsList.url, true

app.initializer.addComponent "ProjectDocumentView", "project-document-view-column", (item)->
  window.projectDocumentView = item
