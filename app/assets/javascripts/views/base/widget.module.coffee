class Widget
  constructor: (el, options={})->
    _.extend @, Backbone.Events
    @el = $ el
    @url = @el.data "url"
    @empty = @el.data "empty"
    @empty ||= false
    @watchPeriod = @el.data "watch"
    @watch = _.debounce @watch, parseInt(@watchPeriod)
    @active = false
    @init(options)
    @activateBindings()
    @remote = @el.data "remote"
    @channelTemplate = $.trim(@el.data "channel-template")
    IQ300.Plugin.use "pusher",  =>
      @_applyPusher()
    unless @remote
      @page = 1
      @lastPage = false
    app.initializer.initialize @el.children()
    @bindings()

  isActive: =>
    @active

# Pusher api private methods
  _applyPusher: =>
#    try
      channelStr = $.trim(@el.data "channel")
      if channelStr
        @_initPusher()
        if window.pusher
          @_subscribe(@_channelOptions(channelStr))
#    catch e
#      console && console.error(e)

  _initPusher: =>
    unless window.pusher
      appKey = $('#pusher_app_key').val()
      unless appKey
        alert 'Pusher app key required!!!'
        return false
      window.pusher = new window.Pusher appKey if window.Pusher

  _subscribe: (channelOptions)=>
    return false unless channelOptions
    @channel = window.pusher.channel channelOptions.name
    @channel =  window.pusher.subscribe channelOptions.name  unless @channel
    for event in channelOptions.events
      @channel.bind event, =>
        @watch()

  _channelOptions: (channelStr)=>
    return undefined unless channelStr
    channelOptions = channelStr.split ':'
    if channelOptions[0] && channelOptions[1]
      { name: channelOptions[0], events: channelOptions[1].split(',') }
    else
      undefined

  _channelStrById: (id)=>
    return undefined unless @channelTemplate
    @channelTemplate.replace(/%(id)%/, id)

# Pusher api public method
  changeChannel: (id=@id)=>
    return false unless window.pusher
    channelStr = @_channelStrById(id)
    channelOptions = @_channelOptions channelStr
    if channelOptions
      if @channel && @channel.name != channelOptions.name
        @channel.unsubscribe()
      @_subscribe(channelOptions)

# end Pusher methods

  init: (options)=>
    #template method

  activateBindings: =>
    inputsSelector = "input[type='text'], textarea, span.best_in_place"

    $(inputsSelector, @el).on "focusin", =>
      @active = true
    .on "focusout", =>
      @active = false

  watch: (data)=>
  #   if @remote
    if !@empty && !@isActive()
      @refreshInQueue = false
      @refresh(data)
    else
      unless @refreshInQueue
        @refreshInQueue = true
        setTimeout @watch, 5000

  getUrl: =>
    @url

  animatedContainer: =>
    @el

  refresh: (callback=undefined, animated=true)=>
    @url = @el.data "url" unless @getUrl()
    @animatedContainer().addClass('is-loading') if animated
    if @url && $.contains(document, @el[0])
      $.ajax
        url: @url
        data: @getParams()
        type: "GET"
        success: (response)=>
          @draw(response)
          callback?()
        error: window.errorHandler
        complete: =>
          @animatedContainer().removeClass('is-loading') if animated
          @onRefreshComplete()

  draw: (response)=>
    unless @isActive()
      data = $ response
      app.initializer.initialize data
      @el.html data
      @bindings()
  # TODO Uncaught TypeError: Object #<r> has no method 'trigger'
  #   @trigger "updated"

  getParams: =>
    @params


  clean: =>
    @el.empty()


  bindings: =>
    # template method

  onRefreshComplete: =>
    # template method

module.exports = Widget
