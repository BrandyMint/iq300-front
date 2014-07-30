class window.TypeaheadComp
  constructor: (el)->
    @el = $ el

    #params
    @url = "#{@el.data('url')}.json"
    @displayField = @el.data('display-field') or null

    IQ300.Plugin.use "typeahead", =>
      #init
      @el.typeahead
        ajax:
          url: @url,
          method: 'get',
          timeout: 300,
          displayField: @displayField
          triggerLength: 3,
          preDispatch: (query) ->
            search_word: query
        onselect: (obj) ->
          document.forms["search-form"].submit()

#app.initializer.addComponent 'TypeaheadComp', 'typeahead-comp'