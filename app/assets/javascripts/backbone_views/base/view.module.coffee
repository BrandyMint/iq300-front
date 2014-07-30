class View extends Backbone.View
  initialize: =>
    @render() if @autoRender

  render: =>
    @$el.html(JST["templates/#{@template}"](@getTemplateData()))  if @template
    @domBindings?()

    @

  getTemplateData: =>
    res = @helpers || {}
    res.model = @model
    res.options = @options
    res

  refresh: =>
    @$el.empty()
    @$el.html(JST["templates/#{@template}"](@getTemplateData())) if @template
    @domBindings?()
    @

  domBindings: =>
#    @$el.toggle !@model.get("hidden") if @model
    if @model
      if @model.get("hidden") then @$el.addClass('removed') else @$el.removeClass('removed')

  unbind: =>
    @stopListening()
    # template method

  helpers:
    urlFor: (obj, params)->
      className = obj.className()
      type = className.charAt(0).toLowerCase() + className.slice 1
      if params.primaryKey
        key =  obj.get(params.primaryKey)
      else
        key = obj.id
      appendix = ""
      prefix = ""
      if params.namespace
        prefix = "/#{params.namespace}/"
      if params.method
        appendix += "/#{params.method}"
      if params.query
        appendix += "?#{params.query}"
      "#{prefix}#{_.pluralize(type)}/#{key}#{appendix}"

module.exports = View