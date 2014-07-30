class Editor
  config:
    value: ''

  ui:
    textarea: 'textarea'
    saveButton: "[role='save-button']"
    cancelButton: "[role='cancel-button']"
    deleteButton: "[role='delete-button']"

  constructor: (el, options = {})->
    _.extend @, Backbone.Events

    @$el = $(el)

    @_setUi()
    @val(options.value or @config.value)
    @bindings()

  show: =>
    @$el.show()
    @textarea.focus()
    @trigger('show')

  hide: =>
    @$el.hide()
    @trigger('hide')

  val: (value=null)=>
    if (value or value == '') then @textarea.val(value) else @textarea.val()

  bindings: =>
    @cancelButton.bind 'click', @cancel
    @saveButton.bind 'click', @save
    @deleteButton.bind 'click', @del
    @textarea.bind 'keypress', (event)=>
      @save(event) if event.keyCode == 13

  cancel: (event)=>
    event.preventDefault()
    @hide()
    @_reset()
    @trigger('cancel')

  save: (event)=>
    event.preventDefault()
    value = _.trim(@val())
    object = { value: value }
    @hide()
    @_reset()
    @trigger('save', object) if value != ''

  del: (event)=>
    event.preventDefault()
    @hide()
    @_reset()
    @trigger('delete')

  _reset: =>
    @textarea.val('')

  _setUi: =>
    @textarea = $(@ui.textarea, @$el)
    @saveButton = $(@ui.saveButton, @$el)
    @cancelButton = $(@ui.cancelButton, @$el)
    @deleteButton = $(@ui.deleteButton, @$el)

module.exports = Editor