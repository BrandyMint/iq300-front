class window.SearchExpander extends window.Expander

  expand: =>
    super
    @target.css "display", ""
    @target.trigger "expanded"

app.initializer.addComponent "SearchExpander"