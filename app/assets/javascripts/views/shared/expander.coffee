class window.Expander
  constructor: (el)->
    @el = $ el
    @target = @el.parent().siblings @el.data('target')
    @el.click @_expand if @el.data('target')
    @expandedClass = @el.data('expanded-class') || 'expanded'
    @expand()  if @el.data "expand-on-init"


  _expand: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @expand()

  expand: =>
    return false unless @target
    @el.parent().toggleClass @expandedClass
    @target.toggleClass @expandedClass

app.initializer.addComponent "Expander"