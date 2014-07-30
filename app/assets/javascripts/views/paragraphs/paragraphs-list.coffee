Widget = require 'views/base/widget'

class window.ParagraphsList extends Widget
  init: =>
    @filters = ["folder", "categories", "sort", "search", "teammate", "period"]

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    @params = _(@params).extend {"_": new Date().getTime()}
    for filter in @filters
      @params[filter] = @router().getParam filter
    @params

  getParamsStr: =>
    str=''
    for key, value of @getParams()
      if value != undefined && key != undefined
        str += "#{key}=#{value}&"
    str

  router: =>
    window.tasksRouter

  bindings: =>
    @container = $ '.paragraphs-list-inner > ul.paragraphs', @el
    @creationLink = $ '#add_top_level_paragraph', @el
    @creationLink.unbind 'click'
    @creationLink.click @addParagraph
    @hoverBindings()

  hoverBindings: =>
    paragraphs = $ ".paragraph-item", @el
    paragraphs.unbind 'mouseover'
    paragraphs.bind 'mouseover', @onHover


  onHover: (ev)=>

    ev.stopPropagation()
    target = $(ev.currentTarget)
    unless @hoveredItem
      @hoveredItem = $('li.paragraph-item.hovered', @el)
    unless target.hasClass 'hovered'
      @hoveredItem.removeClass "hovered"
      target.addClass "hovered"
      @hoveredItem = target

#    $('li.paragraph-item.hovered', @el).removeClass "hovered"
##    if ev.type == "mouseenter"
#    $(ev.currentTarget).addClass "hovered"

  addParagraph: (ev)=>
    target = $ ev.currentTarget
    return false if target.hasClass 'is-loading'
    $.ajax
      type: 'post',
      url: target.data('url'),
      success: (data, status, xhr) =>
        html = $ data
        app.initializer.initialize html
        @container.append html
        app.initializer.initializeOnly 'ParagraphView', @container
        window.taskView.activateBindings()
        @bindings()
      error: (xhr)=>
        window.errorHandler xhr
      beforeSend: =>
        @sending = true
        @creationLink.addClass('is-loading')
      complete: =>
        @sending = false
        @creationLink.removeClass('is-loading')

    ev.preventDefault()

app.initializer.addComponent "ParagraphsList", 'paragraphs-list-column', (obj)=>
  window.paragrphsList = obj
