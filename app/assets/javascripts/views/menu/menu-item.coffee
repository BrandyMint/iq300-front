class window.MenuItem
  constructor: (el) ->
    @el = $ el
    @url = @el.data('url').replace /^\//, '' # removed primary slash
    @params = @el.data 'params'

  refresh: =>
    if @url
      window.countersManager.push @url,
        data: @params
        success: @draw

  draw: (response) =>
    sup = $ 'sup', @el
    sup.remove()
    if response != 0 && response != undefined
      data = "<sup>#{response}</sup>"
      $('.picture', @el).append data