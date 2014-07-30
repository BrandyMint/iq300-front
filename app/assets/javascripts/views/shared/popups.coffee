class window.Popup
  reset: =>
    $("body").click (ev)=>
      target = $ ev.target
      if target.hasClass(".#{@className}") || target.parents(".#{@className}").length > 0 || target[0] is @el[0] || @parentsIncludesEl(target)
      else
        @hide()

  parentsIncludesEl: (el)=>
    if el.parents("[data-popup]").length > 0
      results = for parent in el.parents("[data-popup]")
        parent == @el[0]
      _(results).compact().length == el.parents("[data-popup]").length
    else
      false

  constructor: (el)->
    @el = $ el
    @className = @el.data "popup"
    @offsetTop = @el.data("offset-top") || 30
    @offsetLeft = @el.data("offset-left")
    @positioning = @el.data "position"

    @popup().addClass("popup-window")
    @el.unbind 'click'
    @el.click @showPopup
    $(window).on 'drag:start', @hide
    @reset()

  popup: =>
    $ ".#{@className}"

  showPopup: (ev)=>
    ev.stopPropagation()
    if @popup().length > 1
      target = $ ev.currentTarget
      popup = target.closest(".#{@className}").addClass("popup-window")
    else
      popup = @popup()

    focusedInput = $ popup.data('focused-input'), popup if popup.data('focused-input')

    if @positioning == "calculate"
      offset = @el.offset()
      popup.css "position", "fixed"
      popup.css "top", offset.top + @offsetTop
      popup.css "left", offset.left + @el.width() / 2 - (@offsetLeft || popup.width()/2)

    closeLink = $ 'a.close', popup
    closeLink.click(@hide) if closeLink

    popup.trigger "popup:shown"
    popup.toggleClass "shown"

    if focusedInput
      setTimeout =>
        focusedInput.focus()
      , 0
#    ev.preventDefault()

  hide: =>
    el = if @popup().length > 1 then @el.closest(".#{@className}") else @popup()
    el.removeClass "shown"

app.initializer.addComponent "Popup", "popup-window"





