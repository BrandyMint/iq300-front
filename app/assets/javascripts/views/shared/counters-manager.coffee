class CountersManager
  constructor: (options = {}) ->
    @url = options.url || '/counters'
    @waitTime = 1000
    @reset()
    @number = 0

  push: (name, options = {}) =>
    @number += 1
    clearTimeout @timeoutId if @timeoutId
    @params[name] = {} unless @params[name]
    data = options.data || {}
    @params[name][@number] = data

    @callbacks[@number] = options.success
    @timeoutId = setTimeout @send, @waitTime

  send: =>
    $.ajax
      url: @url
      data:
        counters:
          @params
      type: 'GET'
      success: @applyCallbacks

  applyCallbacks: (data) =>
    for number, callback of @callbacks
      callback? data[number]
    @reset()

  reset: =>
    @callbacks = {}
    @params = {}

window.countersManager = new CountersManager #временное решение, до появления AMD
