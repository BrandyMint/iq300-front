class window.SelectTwo
  constructor: (el)->
    @el = $ el

    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', @init

  init: =>
    #params
    @width = @el.data('width') or 'resolve'
    @tags = @el.data('tags')
    @allowClear = @el.data('allow-clear') or false
    @remote = @el.data('remote') or false
    if @remote
      @url = @el.data('url')
      @min = @el.data('minimum-input-length') or 3
      @selectedValue = @el.data('selected-value')
      @selectedValueTitle = @el.data('selected-value-title')
    #init
    if @remote
      options =
        width: @width
        tags: @tags
        allowClear: @allowClear
        minimumInputLength: @min
        ajax:
          url: @url
          dataType: 'json'
          quietMillis: 500
          data: (term)->
            { search: term, format: 'json' }
          results: (data)->
            { results: data }
        formatResult: @formatResult
        formatSelection: @formatSelection

      if @selectedValue
        extraOpts =
          initSelection: (element, callback) =>
            callback {id: @selectedValue, full_name: @selectedValueTitle}
        options = _.extend(options, extraOpts)

      @el.select2(options)

    else
      @el.select2
        width: @width
        tags: @tags
        allowClear: @allowClear

  formatResult: (result)->
    result.full_name

  formatSelection: (selection)->
    selection.full_name
