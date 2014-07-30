class Model extends Backbone.Model
  className: =>
    return @_classNameCached if @_classNameCached
    str = @constructor.toString().match(/function (\w+)\(.*/)
    @_classNameCached = str[1] if str

  delayedDestroy: =>
    @set 'hidden', true

  visible: =>
    !@get 'hidden'

  initialize: =>
    @deleteOnRestore = false
    @attributes.hidden = false
    options = arguments[1] || {}
    @skipWatching = options.skipWatching || false

  destroyDependencies: =>
    []

module.exports = Model
