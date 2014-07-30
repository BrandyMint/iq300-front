class window.IntegratedForm
  constructor: (container)->
    @container = $ container
    @el = $  'form', @container
    @relatedClass = @container.data('related-el')
    @relatedEl = $ '.' + @relatedClass
    formOptions =
      target: @el,
      success: @renderResponse
    IQ300.Plugin.use "jquery-form", =>
      @el.ajaxForm formOptions

  renderResponse: =>
    @relatedEl.empty()
    @relatedEl.removeClass "#{@relatedClass}-initialized"
    app.initializer.initialize(document)

app.initializer.addComponent 'IntegratedForm', 'integrated-form'