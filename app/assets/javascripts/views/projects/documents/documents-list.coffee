Widget = require 'views/base/widget'

class window.ProjectDocumentsList extends Widget
  init: =>
    @filters = ["page", "tag", "in_trash_can"]

  getParams: =>
    @params = {active: @activeLine}
    for filter in @filters
      @params[filter] = window.window.projectDocsRouter.getParam filter
    @params

  bindings: =>
    @documents = $ ".document-item", @el
    @docOpenLink = $ ".doc-description", @el
    @docOpenLink.click @showDocument
    @searchContainer = $ ".search-by-tag", @el
    @searchByTagSelect = $ "select.select-two", @searchContainer
    @searchByTagSelect.change @searchByTag
    @clearSearchLink = $ 'a.reset-search', @searchContainer
    @clearSearchLink.click @resetSearch
    @destroyRestoreLink = $ 'a.destroy-restore-document', @el
    @destroyRestoreLink.click @destroyRestoreDoc
    @trashcanLink = $ "a.trashcan", @el
    @trashcanLink.click @showTrashcan

  showTrashcan: (e)=>
    e.preventDefault()
    target = $ e.currentTarget
    state = target.data 'state'
    window.projectDocsRouter.deleteParam 'in_trash_can'
    if state == 'trashcan'
      window.projectDocsRouter.setParam 'in_trash_can', 'true'
    @active = false
    @refresh()

  destroyRestoreDoc: (e) =>
    e.preventDefault()
    target = $ e.currentTarget
    url = target.attr("href")
    method = target.data 'method'
    confirm = window.confirm target.data('confirmation')
    if confirm
      $.ajax
        url: url
        type: method
        error: window.errorHandler
        success: =>
          target.parent().remove()
    false

  resetSearch: (e)=>
    e.preventDefault()
    window.projectDocsRouter.deleteParam 'tag'
    @active = false
    @refresh()

  searchByTag: (e)=>
    tag =  @searchByTagSelect.val()
    window.projectDocsRouter.deleteParam 'tag'
    window.projectDocsRouter.setParam 'tag', tag
    @active = false
    @refresh()

  showDocument: (ev)=>
    ev.preventDefault()
    target = $ ev.currentTarget
    @activeLine = target.data "id"
    isTrashCan = window.projectDocsRouter.getParam 'in_trash_can'
    unless isTrashCan == undefined
      additionalParam = '?in_trash_can=true'
    else
      additionalParam = ''
    window.projectDocsRouter.navigate "#{@url}/#{@activeLine}#{additionalParam}", true

app.initializer.addComponent "ProjectDocumentsList", 'project-documents-list-column', (obj)=>
  window.projectDocumentsList = obj
