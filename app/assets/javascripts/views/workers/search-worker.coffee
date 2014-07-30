class window.SearchWorkerView
  constructor: (el)->
    @el = $(el)
    @results = $('.results', @el)
    @input = $('input#search', @el)
    @form = @input.closest('form')
    @url = @form.attr 'action'
    @forValue = $('input#for', @el).val()
    @departmentId = $('input#department_id', @el).val()
    unless  @departmentId
      @departmentId = ''
    IQ300.Plugin.use "typeahead", =>
      @input.typeahead
        remote:
          url: "#{@url}?search=%QUERY&for=#{@forValue}&unallocated=true&department_id=#{@departmentId}"
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
            app.initializer.initialize @results
            @results
  #            .find('li form').on('submit', window.contactsList.createContact)
  #            .find('.name a').on('click', window.contactsList.showContact)
  #            .parents('li').addClass('contact-exists')
            false

app.initializer.addComponent "SearchWorkerView", "search-worker-for-community", (obj) ->
  window.searchWorkerView = obj
