Widget = require 'views/base/widget'

class window.TodoItem extends Widget

  bindings: =>
    @todoRemoveLink = $ '.remove', @el
    @todoCheckbox = $ ':checkbox', @el
    @todoEditLink = $ '.edit', @el
    @todoRemoveLink.click @removeTodo
    @todoCheckbox.click @completeTodo
    @todoEditLink.click @editMode
    @title =  $ '.title', @el
    @title.bind 'click', @completeTodo
    @url = @el.data 'url'
    @form = $ '.edit-form', @el
    @form.submit @updateTodo
    @input = $('#todo_item_title', @form)

  updateTodo: (ev)=>
    data = @form.serialize()
    titleValue = @input.val()
    if titleValue
      $.ajax
        type: 'put',
        url: @url,
        data: data
        success: (data, status, xhr) =>
          @title.html titleValue
          @el.removeClass 'editing'
#          @title.effect 'highlight', {}, 2000
          @title.hide()
          @title.fadeIn()
        error: window.errorHandler
    false

  editMode: (ev)=>
    window.todoList.stopEditing()
    @el.toggleClass 'editing'
    setTimeout =>
      @input.focus()
    , 0
    false

  completeTodo: (ev)=>
    @el.toggleClass('done')
    isCompleted = @el.hasClass('done') ? '1' : '0'
    window.todoList.refreshCounter()
    if $(ev.target).hasClass('title')
      @todoCheckbox.prop('checked', !@todoCheckbox.prop('checked'))
    $.ajax
      type: 'put',
      url: @url,
      data: { todo_item: { completed: isCompleted}}
      error: window.errorHandler

  removeTodo: (ev)=>
    target = $ ev.currentTarget
    confirm = window.confirm target.data('confirmation')
    if confirm
      $.ajax
        type: 'delete',
        url: @url
        success: (data, status, xhr) =>
          @el.remove()
          window.todoList.refreshCounter()
        error: window.errorHandler
    false

app.initializer.addComponent "TodoItem", 'todo-item'