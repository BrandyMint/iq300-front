class window.SearchContactView
  constructor: (el)->
    @el = $(el)
    @results = $('.results', @el)
    @input = $('input#search', @el)
    @form = @input.closest('form')
    @forValue = $('input#for', @el).val()
    IQ300.Plugin.use "typeahead", =>
      @input.typeahead
        remote:
          url: "/users?search=%QUERY&for=#{@forValue}"
          dataType: 'html'
          rateLimitFn: 'throttle'
          rateLimitWait: 1000
          beforeSend: =>
            if @input.val().length >= 2
              @form.find('button .icon-search').hide().parent().addClass('is-loading')
            else
              false
          filter: (res) =>
            @results.hide().html(res).slideDown('fast')
            @form.find('button').removeClass('is-loading').find('.icon-search').show()
            @results
              .find('li form').on('submit', window.contactsList.createContact)
              .find('.name a').on('click', window.contactsList.showContact)
              .parents('li').addClass('contact-exists')
            false

app.initializer.addComponent "SearchContactView", "create-contact-window", (obj) ->
  window.searchContactView = obj
