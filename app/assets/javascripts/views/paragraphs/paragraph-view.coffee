Widget = require 'views/base/widget'

class window.ParagraphView extends Widget
  bindings: =>
    @container = $ '> ul.sublist', @el

    @controls = $ ' > .paragraph-controls', @el

    @paragraphsLinks = $ '> .name .discussion-btn', @el
    @paragraphsLinks.unbind 'click'
    @paragraphsLinks.click @showParagraph

    @creationLink = $ '.add-paragraph', @controls
    @creationLink.unbind 'click'
    @creationLink.click @addParagraph

    @deleteLink = $ '.remove-paragraph', @controls
    @deleteLink.unbind 'click'
    @deleteLink.click @deleteParagraph

    @positionLinks = $ '.change-paragraph-position', @controls
    @positionLinks.unbind 'click'
    @positionLinks.click @doAction

    @toTaskLink = $ '.convert-to-task', @controls
    @toTaskLink.unbind 'click'
    @toTaskLink.click @doAction

  unbinndings: =>
    @paragraphsLinks.unbind 'click'
    @creationLink.unbind 'click'
    @deleteLink.unbind 'click'
    @positionLinks.unbind 'click'
    @toTaskLink.unbind 'click'

  showParagraph: (ev)=>
    return false if @el.hasClass 'is-loading'
    @el.addClass('is-loading')
    target = $ ev.currentTarget
    @activeLine = target.data "id"
    @list().router().navigate "tasks/#{@activeLine}?#{@list().getParamsStr()}", true
    setTimeout @unbinndings, 0
    window.displayMode.enableMode("view")

  addParagraph: (ev)=>
    ev.stopPropagation()
    target = $ ev.currentTarget
    return false if @el.hasClass 'is-loading'
    $.ajax
      type: 'post',
      url: target.data('url'),
      success: (data, status, xhr) =>
        html = $ data
        app.initializer.initialize html
        @container.append html
        app.initializer.initializeOnly 'ParagraphView', @container
        @container.removeClass 'empty'
        @list().hoverBindings()
        window.taskView.activateBindings()
      error: (xhr)=>
        window.errorHandler xhr
      beforeSend: =>
        @sending = true
        @el.addClass('is-loading')
      complete: =>
        @sending = false
        @el.removeClass('is-loading')

    ev.preventDefault()

  list: =>
    window.paragrphsList

  deleteParagraph: (e) =>
    e.stopPropagation()
    return false if @el.hasClass 'is-loading'
    target = $ e.currentTarget
    url = target.data "url"
    unless target.data('confirmation') == undefined
      confirm = window.confirm target.data('confirmation')
    else
      confirm = true
    if confirm
      @active = false
      $.ajax
        url: url
        type: "POST"
        data: {_method: 'delete'}
        success: (data, status, xhr) =>
          @unbinndings()
          @el.remove()
        beforeSend: =>
          @sending = true
          @el.addClass('is-loading')
        complete: =>
          @sending = false
          @el.removeClass('is-loading')
    false

  doAction: (ev)=>
    return false if @el.hasClass 'is-loading'
    target = $ ev.currentTarget
    unless target.data('confirmation') == undefined
      confirm = window.confirm target.data('confirmation')
    else
      confirm = true
    if confirm
      $.ajax
        type: 'put',
        url: target.data('url'),
        success: (data, status, xhr) =>
          html = $ data
          if target.hasClass 'change-paragraph-position'
            @list().container.html html
            app.initializer.initialize @list().container
          else
            @el.html html
            app.initializer.initialize html
            @bindings()
        beforeSend: =>
          @sending = true
          @el.addClass('is-loading')
        complete: =>
          @sending = false
          @el.removeClass('is-loading')

    ev.preventDefault()

#  add_category: (e) =>
#    tag =  @categories_select.val()
#    $(e.target).select2 'data', null
#    $.ajax
#      url: @categories_select.data('url')
#      type: "PUT"
#      data:
#        tag: tag
#      success: (data) =>
#        $('.badges-list .add-button', @el).before(data)
#        @categories_select.val("")
#
#  remove_category: (e) ->
#    e.preventDefault()
#    $remove_link = $(this)
#    url = $remove_link.attr("href")
#    $.ajax
#      url: url
#      type: "DELETE"
#      success: ->
#        $remove_link.parent().remove()

app.initializer.addComponent "ParagraphView", "paragraph-item"
