class window.CategoriesView
  constructor: (el)->
    @el = $ el
    @formContainer =  $ '.adding-form', @el
    @form = $ 'form', @formContainer
    @addTagLink = $ '.add-tag', @el
    @addTagLink.click @showForm
    @form.submit @submitForm
    @categoriesSelect = $ "input.select-two", @el
    @categoriesSelect.change @addCategory
    @resetBtn = $ "input[type='reset']", @formContainer
    @resetBtn.click @closeForm
    @bindings()
    @init()

  closeForm: (ev)=>
    ev.preventDefault()
    @formContainer.hide()
    @addTagLink.parent().toggle()

  init: =>
    @removLinks = $ '.remove-category', @el
    @removLinks.click @removeCategory

  bindings: =>
    # template method

  submitForm: (ev)=>
    ev.preventDefault()
    tag = @categoriesSelect.val()
    unless tag == ''
      @addCategory()


  docsList: (ev)=>
    target = $ ev.currentTarget
    ev.stopPropagation()
    ev.preventDefault()
    tag = target.data 'tag'
    window.tasksRouter.setParam 'tag', tag
    window.projectDocumentsList.active = false
    window.projectDocumentsList.refresh()


  showForm: (ev)=>
    ev.preventDefault()
    @addTagLink.parent().toggle()
    @formContainer.show()
    setTimeout =>
      $('.select2-search-field', @el).click()
    , 0

  addCategory: (e) =>
    tag =  @categoriesSelect.val()
    $(e.target).select2 'data', null
    $.ajax
      url: @categoriesSelect.data('url')
      type: "POST"
      data:
        tag: tag
      success: (data)=>
        $('.add-button', @el).before(data)
        @categoriesSelect.val("")
        @init()
        @bindings()
      error: window.errorHandler

  removeCategory: (e) =>
    e.preventDefault()
    $removelLink = $ e.currentTarget
    url = $removelLink.attr("href")
    $.ajax
      url: url
      type: "DELETE"
      success: =>
        $removelLink.parent().remove()

app.initializer.addComponent "CategoriesView", 'categories-view'