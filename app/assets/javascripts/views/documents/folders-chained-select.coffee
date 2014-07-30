class window.FoldersChainedSelect
  constructor: (el)->
    @el = $ el
    @parentSelector = @el.data "parent-selector"
    @parent = @el.parents(@parentSelector).first()
    @dataChainedSelect = @el.data "chained-select"
    @regExp = /__(.*)__/
    @targetName = unescape @dataChainedSelect.match(@regExp)[1]
    @nullValue = @el.data "null-value"
    @target = $ "[name='" + @targetName + "']", @parent
    @placeholder = @el.data "placeholder"
    if @target
      @target.bind "change select2-clearing", @getOptions
    @initilizeSelect2()

  getOptions: ()=>
    val = @target.val() || @nullValue
    @el.data 'selected-value', val
    @initilizeSelect2()

  initilizeSelect2: =>
    @el.empty()
    @el.val ""
    @itemsPerPage = 20
    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', =>
        @el.select2
          placeholder: @placeholder
          minimumInputLength: 0
          allowClear: true
          ajax:
            url: @getUrl()
            dataType: "json"
            data: (term, page) ->
              search: term
              per: 20
              page: page
            results: (data, page) =>
              more = (page * @itemsPerPage) < data.total
              results: data.folders, more: more
          formatResult: @folderFormatResult
          formatSelection: (folder) =>
            "<div class=\"folder\">#{folder.title}</div>"
          dropdownCssClass: "bigdrop"
          escapeMarkup: (m) ->
            m
          initSelection: (element, callback)=>
            $.ajax
              type: "GET"
              url: @getUrl()
              dataType: "json"
              data:
                id: element.val()
              success: (data)=>
                folder = data.folders[0]
                if folder
                  callback {id: folder.id, title: folder.title}

  folderFormatResult: (data)=>
    "<div class=\"folder\"><i class=\"icon-folder-close\"></i>#{data.title}</div>"

  getUrl: =>
    @url = @el.data('url').replace(@regExp, @el.data "selected-value")
    @url

app.initializer.addComponent "FoldersChainedSelect"
