class window.RemoteFormUpdater
  constructor: (container)->
    @container = $ container
    @target = @container.data 'target'
    if @target
      @target_el = $('#'+@target)
      @container.bind 'ajax:complete', @draw

  draw: (xhr, data, status)=>
    @target_el.html data.responseText
    app.initializer.initialize @target_el

app.initializer.addComponent 'RemoteFormUpdater', 'remote-form-updater'