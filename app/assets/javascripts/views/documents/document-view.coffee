WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.DocumentView extends WidgetItemTabs
  init: ->
    super
    @shareLinkPopup = $ '.share-link-popup'
    @id = @el.data 'id'


  show: (id)=>
    @id = id
    @empty = false
    @notFirstTime = true
    @refresh =>
      attachmentId = $("#doc-details", @el).data "attachment-id"
      @changeChannel(attachmentId)

  getUrl: =>
    @url = "/docs/#{@id}"
    @url

  getParams: =>
    {}

  destroyRestoreDoc: (event)=>
    event.preventDefault()
    event.stopPropagation()
    link = $ event.currentTarget
    confirmText = link.data 'confirm'
    confirmed = if confirmText
                  confirm(confirmText)
                else
                  true
    if confirmed
      $.ajax
        url: link.attr 'href'
        method: link.data 'method'
        dataType: 'json'
        success: @refresh
        error: window.errorHandler
    false

  showSharePopup: (ev)=>
    ev.preventDefault
    target = $ ev.currentTarget
    input = $('input', @shareLinkPopup)
    input.val(target.attr "href")
    @shareLinkPopup.toggleClass 'shown'
    input.select()
    false

  router: =>
    window.documentsRouter

  list: =>
    window.documentsList

  bindings: =>
    super
    @tabUrls = $ "header.tab-navigation ul.tabnav li", @el
    @shareLink = $ "a.share-link", @el
    @shareLink.unbind "click"
    @shareLink.click @showSharePopup
    @tabUrls.click @showTab
    @destroyLink = $ "a.remove", @el
    @recoverLink = $ "a.recover", @el
    @destroyLink.unbind "click"
    @recoverLink.unbind "click"
    @destroyLink.click @destroyRestoreDoc
    @recoverLink.click @destroyRestoreDoc
    $('a.sub-document', @el).click (ev)=>
      targetId = $(ev.currentTarget).data 'id'
      @show targetId if targetId


  showTab: (ev) =>
    target = $ ev.currentTarget
    link = $ 'a', target
    @router().navigate link.attr('href'), true

app.initializer.addComponent "DocumentView", "folders-view-column", (item)->
  window.documentView = item
