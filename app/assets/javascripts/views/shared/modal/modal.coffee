class window.Modal
  constructor: (el)->
    @el = $ el
    @remote = @el.data 'remote'
    @width = @el.data 'width'
    @openLinks = $ "a[data-toggle='modal']"
    @openLinks.click @loadingMode

  loadingMode: =>
    @el.modal
      show: false
      loading: false
      remote: @remote
      width: @width

