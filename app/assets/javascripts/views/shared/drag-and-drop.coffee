class window.DragAndDrop
  constructor: (el)->
    @el = $ el
    IQ300.Plugin.use 'jquery-drag-and-drop', @init

  init: =>
    @el.dragdrop()

app.initializer.addComponent 'DragAndDrop'