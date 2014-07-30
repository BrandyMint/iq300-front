class window.UsersCooperation
  constructor: (el) ->
    @el = $ el
    @bindings()

  bindings: =>
    links = $('a', @el)
    links.unbind 'click'
    links.click @processAction

  processAction: (ev)=>
    link = $(ev.currentTarget)
    role = link.data('role')
    url = link.prop('href')
    switch role
      when 'contact-creator'
        @_addContact(ev, url)
      when 'contact-remover'
        if window.confirm(link.data('confirmation'))
          @_removeContact(ev, url)
        else
          ev.preventDefault()
      when 'messenger'
        @_openConversation(ev, url)
      else
        true

  _addContact: (ev, url)=>
    ev.preventDefault()
    @_sendAjax(url, 'POST')

  _removeContact: (ev, url)=>
    ev.preventDefault()
    @_sendAjax(url, 'DELETE')
    # TODO нужен механизм обмена event-ами
    $(window).trigger('contacts:removed')

  _openConversation: (ev, url)=>
    # задел на будущее, здесь должен активироваться мэссенджер
    true

  _sendAjax: (url, method)=>
    $.ajax
      url: url
      method: method
      success: @_draw
      error: window.errorHandler

  _draw: (response)=>
    @el.fadeOut 'normal', =>
      @el.html response
      @bindings()
      @el.fadeIn()

app.initializer.addComponent 'UsersCooperation'