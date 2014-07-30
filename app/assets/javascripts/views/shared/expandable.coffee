class window.Expandable
  constructor: (container)->
    @el = $ container
    @expander = $ 'a.trigger',  @el
    additionalHeaderSelector = @el.data 'header-selector'
    if additionalHeaderSelector
      @headerText = $ additionalHeaderSelector, @el
      @headerText.click @expand
    @expandedClass = @el.data("expanded-class") || "expanded"
    @expander.click @expand

  expand: (ev)=>
    ev.stopPropagation()
    @el.toggleClass(@expandedClass)
    false


app.initializer.addComponent 'Expandable', 'expandable'