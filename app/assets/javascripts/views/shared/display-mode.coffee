class window.DisplayMode
  constructor: (el)->
    @el = $ el
    $(window).on "new-tab", @enableDisabledModes
    $(window).on "set-mode:full-view", =>
      @enableMode "full-view"
    $('#container').on "swiperight", @swipeRight
    $('#container').on "swipeleft", @swipeLeft
    @bindings()
    if @el.data('process-action') == 1
      @processInitialAction()

  bindings: =>
    @buttons = $ "a.mode-trigger:not(.mode-trigger-initialized)", @el
    @buttons.addClass "mode-trigger-initialized"
    @buttons.click @toggleMode


  toggleMode: (ev)=>
    target = $ ev.currentTarget
    unless target.parent().hasClass('disabled')
      mode = target.attr "mode"
      newState = target.attr("state") != "true"
      @toggleIcon target
      target.attr "state", newState
      @updateMode mode, newState
      $(window).trigger "#{mode}:#{newState}"
    false

  updateMode: (mode, value, router=undefined)=>
    if @container
      if mode == "full-view"
        @updateMode "list", !value
        @updateMode "filters", !value
        @updateMode "view", true
      else
        if mode == "view" && !value
          @updateMode "list", true
          @updateMode "filters", true
        @container.attr mode, value
    unless @getModeState(mode) == value
      @setModeState(mode, value)
    if router
      router.setParam "dm[#{mode}]", value
    else
      @router().setParam "dm[#{mode}]", value

  processInitialAction: =>
    if @el.data('initial-action') == 'index'
      @buttons.filter("[mode=view]").parent().addClass('disabled')

  getModeState: (mode)=>
    @buttons.filter("[mode=#{mode}]").attr("state")

  setModeState: (mode, value)=>
    @buttons.filter("[mode=#{mode}]").attr("state", value)

  isModeEnabled: (mode)=>
    if mode == "full-view"
      @isModeEnabled('view') && @isModeDisabled('list') && @isModeDisabled('filters')
    else
      @container.attr(mode) == "true"

  isModeDisabled: (mode)=>
    if mode == "full-view"
      @isModeDisabled('view') || @isModeEnabled('list') || @isModeEnabled('filters')
    else
      @container.attr(mode) == "false"

  enableMode: (mode, router=undefined)=>
    unless @isModeEnabled(mode)
      @buttons.filter("[mode=#{mode}]").parent().removeClass('disabled')
      @updateMode(mode, "true", router)

  disableMode: (mode, addCss=false, router=undefined)=>
#    unless @isModeDisabled(mode)
    if addCss
      @buttons.filter("[mode=#{mode}]").parent().addClass('disabled')
    @updateMode(mode, "false", router)

  enableDisabledModes: =>
    @el.find('li.disabled').removeClass('disabled')

  toggleIcon: (target)=>
    icon = $ ' > i', target
    newClass = icon.data "opposite-class" if icon
    if newClass
      icon.data 'opposite-class', icon.attr('class')
      icon.attr 'class', newClass
  
  swipeRight: (event)=>
    if $('#container').hasClass('show-filters')
      $('#container').removeClass('show-filters show-list show-navigation');
    else
      $('#container').removeClass('show-filters show-list').addClass('show-navigation');
    
  swipeLeft: (event)=>
    if $('#container').hasClass('show-navigation')
      $('#container').removeClass('show-filters show-list show-navigation');
    else
      $('#container').removeClass('show-navigation show-list').addClass('show-filters');

app.initializer.addComponent "DisplayMode", 'display-mode', (obj)=>
  obj.container = $ ".content"
  obj.router = -> window.tasksRouter
  window.displayMode = obj