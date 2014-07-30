class Initializer
  object = null

  initialize: (el = document) ->
    func? el for key, func of app.initializers

  initializeOnly: (componentName, el = document) ->
    func = app.initializers[componentName]
    func? el

  addComponent: (klass, className, handler) ->
    if _.isObject className
      options = className
    else
      options =
        className: className
        handler: handler
        view: false

    if _.isFunction klass
      componentName = klass.toString().match(/function (\w+)\(.*/)[1]
    else
      componentName = klass
      klass = eval "#{componentName}"
    options.componentName = componentName
    options.constructor = klass

    app.initializers ||= {}
    app.initializers[componentName] = initializeMethodBuilder.build options

  initializeMethodBuilder =
    build: (options) =>
      method = if options.role then "role" else "class"
      initializeMethodBuilder["#{method}Selector"] options

    classSelector: (options) ->
      dasherize = (str)-> str.replace(/\W+/g, '-').replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()
      className = options.className || dasherize(options.componentName)
      initializedClassName = "#{className}-initialized"
      disabledInitializeClassName = "disable-initializer"
      disabledCurrentInitializeClassName = "disable-#{className}"
      (el) ->
        targets = $ ".#{className}:not(.#{initializedClassName}, .#{disabledInitializeClassName}, .#{disabledCurrentInitializeClassName})", el
        targets.each (i, target)->
          item = undefined
          if options.view
            item = new options.constructor {el: target}
          else
            item = new options.constructor target
          $(target).addClass initializedClassName
          options.handler?(item)

    roleSelector: (options) ->
      (el) ->
        targets = $ "[role='#{options.role}']", el
        targets.each (i, target)->
          if options.view
            item = new options.constructor {el: target}
          else
            item = new options.constructor target

          $(target).removeAttr "role"
          $(target).attr "role-ready", options.role
          options.handler?(item)

  @getSingleton: ->
    object ?= new Initializer

module.exports = Initializer.getSingleton()