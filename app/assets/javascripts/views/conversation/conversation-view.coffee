Widget = require 'views/base/widget'

class window.ConversationView extends Widget
  constructor: (el)->
    super
    setTimeout =>
      @scrollDown()
    , 0

  show: (id)=>
    @id = id
    @active = false
    @empty = false
    @refresh =>
#      @scrollDown()
      @changeChannel()

  doAction: (e) =>
    target = $ e.currentTarget
    url = target.prop("href")
    @active = false
    $.ajax
      url: url
      data: @params
      type: "PUT"
      success: @draw
    false

  scrollDown: =>
    $(".column-content",@el).animate scrollTop: @el.find(".comments-list ").height()

  draw: (data)=>
    super
    window.displayMode.bindings()
    @scrollDown()
#    setTimeout =>
#    , 100

  refresh: (callback=undefined)=>
    $.when( $.ajax
      url: @getUrl()
      data: @params
      type: "GET"
      success: (data)=>
        @draw(data)
        callback?()
    ).done =>
      window.menuList.refresh()

  getUrl: =>
    regexp = /\/\d*$/
    if @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"
    @url

  bindings: =>
    super
    @actionLinks = $ "a.action", @el
    @actionLinks.click @doAction
    @inputs = $ 'input', @el
    @activateBindings()

app.initializer.addComponent "ConversationView", "conversation-view-column", (item)->
  window.conversationView = item
