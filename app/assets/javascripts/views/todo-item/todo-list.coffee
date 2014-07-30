Widget = require 'views/base/widget'

class window.TodoList extends Widget

  bindings: =>
    @todosContainer = $ 'ul', @el
    @form = $ '.new-todo', @el
    @progressBar = $ '.progress,*[role="progress"]', @el
    @addBtn = $ '.add-button', @el
    @form.submit @addTodoItem
    @form.hide()
    @addBtn.click @showForm
    @cancelBtn = $ "input[type=reset]", @form
    @cancelBtn.click @hideForm

  addTodoItem: (ev)=>
    data = @form.serialize()
    $.ajax
      type: 'post'
      url: @form.attr 'action'
      data: data
      success: (data, status, xhr) =>
        html = $ data
        @todosContainer.append html
        app.initializer.initialize @el
        $('#todo_item_title', @form).val ''
        @refreshCounter()
      error: window.errorHandler
    false

  showForm: (ev)=>
    ev.preventDefault()
    @form.show()
    @addBtn.hide()
    setTimeout =>
      $('.todo-body', @form).focus()
    , 0

  hideForm: (ev)=>
    ev.preventDefault()
    $('#todo_item_title', @form).val ''
    @form.hide()
    @addBtn.show()

  stopEditing: =>
    todos = $ '.todo-item', @el
    todos.removeClass "editing"
    @form.hide()
    @addBtn.show()


  refreshCounter: =>
    todos = $ '.todo-item', @el
    text = @progressBar.data 'text'
    @progressBar.html( "#{text} #{todos.filter('.done').length}/#{todos.length}")

app.initializer.addComponent TodoList,
  role: 'todo-list',
  handler: (obj)=>
    window.todoList = obj