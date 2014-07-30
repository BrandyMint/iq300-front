class window.MultipleAttachmentsSelect
  constructor: (el)->
    @el = $ el
    @url = @el.data('url')
    @itemsPerPage = 20
    @placeholder = @el.data "placeholder"
    @initilizeSelect2()

  initilizeSelect2: =>
    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', =>
        @el.select2
          placeholder: @placeholder
          minimumInputLength: 0
          multiple: true,
          allowClear: true
          ajax:
            url: @url
            dataType: "json"
            data: (term, page) =>
              search: term
              per: @itemsPerPage
              page: page
            results:  (data, page) =>
              more = (page * @itemsPerPage) < data.total
              res = []
              for item in data.folders
                res.push {id: item.attachment_id, text: item.title}
              results: res, more: more


app.initializer.addComponent "MultipleAttachmentsSelect"
