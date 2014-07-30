class window.SearchUserView
  constructor: (el)->
    @el = $(el)
    @results = $('.results', @el)
    @input = $('input#search', @el)
    @form = @input.closest('form')
    @forValue = $('input#for', @el).val()
    @communityId = $('input#community_id', @el).val()
    IQ300.Plugin.use "typeahead", =>
      @input.typeahead
        remote:
          url: "/users?search=%QUERY&for=#{@forValue}&community_id=#{@communityId}"
          dataType: 'html'
          rateLimitFn: 'throttle'
          rateLimitWait: 1000
          beforeSend: =>
            if @input.val().length >= 2
              @form.find('button .icon-search').hide().parent().addClass('is-loading')
            else
              false
          filter: (res) =>
            @results.hide().html(res).slideDown('fast', =>
              $('form', @results).submit(@inviteUnregistered)
            )
            @form.find('button').removeClass('is-loading').find('.icon-search').show()


            false

  inviteUnregistered: (e)=>
    e.preventDefault()
    form = $ e.target
    $.ajax
      type: form.attr 'method'
      url: form.attr 'action'
      data: form.serialize()
      success: (response)=>
        window.location = response.url
      beforeSend: =>
        @form.find('button .icon-search').parent().addClass('is-loading')
      complete: =>
        @form.find('button').removeClass('is-loading')
      error: window.errorHandler
    false


app.initializer.addComponent "SearchUserView", "search-user-for-community"
