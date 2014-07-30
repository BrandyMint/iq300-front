Editor = require('views/projects/form/inputs_manager/editor')
Input = require('views/projects/form/inputs_manager/input')

class InputsManager

  ui:
    input: "[role='input']"
    list: "[role='list']"
    editor: "[role='editor']"
    addButton: "[role='add-button']"

  constructor: (el)->
    @$el = $(el)

    @fieldBegin = @$el.data('field-begin')
    @fieldEnd = @$el.data('field-end')
    @currentInput = null

    @_setUi()
    @bindings()

  bindings: =>
    @addButton.bind 'click', @newInput
    @editor.bind 'save', @saveInput
    @editor.bind 'delete', @deleteInput
    @editor.bind 'cancel', @_reset

  newInput: (event)=>
    event.preventDefault()
    @editor.show()

  editInput: (input)=>
    @currentInput = input
    @editor.val(@currentInput.val())
    @editor.show()

  saveInput: (object)=>
    if @currentInput
      @updateInput(object)
      @_reset()
    else
      @createInput(object)
      @editor.show()

  createInput: (object)=>
    @_formatObject(object)
    html = JST['templates/projects/form/input'](object)
    @list.append(html)
    @_initializeInput($(@ui.input, @$el).last())

  updateInput: (object)=>
    @currentInput.val(object.value)

  deleteInput: =>
    if @currentInput
      @currentInput.remove()
      @_reset()

  _initializeInput: (el)=>
    input = new Input(el)
    input.bind 'click', @editInput

  _formatObject: (object)->
    object.inputName = "#{@fieldBegin}[]#{@fieldEnd}"
    object.checkboxName = "#{@fieldBegin}[][_destroy]"

  _setUi: =>
    @editor = new Editor($(@ui.editor, @$el))
    @addButton = $(@ui.addButton, @$el)
    @list = $(@ui.list, @$el)
    @_initializeInput(el) for el in $(@ui.input, @$el)

  _reset: =>
    @currentInput = null

module.exports = InputsManager