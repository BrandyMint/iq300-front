class window.DepartmentsList
  constructor: (el) ->
    @el = $ el
    @departments = $("li.department-item", @el)
      .click (e) =>
        target = $(e.currentTarget)
        url = target.data "url"
        if url then window.location = url

    @links = $ 'a', @departments
    @links.click @clickWithConfirm

  clickWithConfirm: (e)=>
    target = $(e.currentTarget)
    confirmation = target.data('confirmation')
    if confirmation
      confirm = window.confirm  confirmation
      if confirm
        true
      else
        e.stopPropagation()
        e.preventDefault()
    else
      true

app.initializer.addComponent "DepartmentsList", "departments-list-column", (obj) ->
  window.departmentsList = obj
