class Router extends Backbone.Router
  initialize: =>
    @params = new Uri window.location.search

  before: =>
    @params = new Uri window.location.search

  setParam: (key, value)=>
    if @getParam(key) != undefined
      @params.replaceQueryParam key, value
    else
      @params.addQueryParam key, value
    @__updatePath()

  getParam: (key)=>
    @params.getQueryParamValue key

  deleteParam: (key)=>
    @params.deleteQueryParam key
    @__updatePath()

  __updatePath: =>
    path = window.location.pathname
    window.history.pushState {}, document.title, "#{path}#{@params.toString()}"

module.exports = Router