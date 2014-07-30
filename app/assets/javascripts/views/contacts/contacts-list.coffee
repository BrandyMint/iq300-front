WidgetList = require 'views/base/widget_list'

class window.ContactsList extends WidgetList
  init: =>
    super
    # TODO нужен механизм обмена event-ами
    $(window).bind 'contacts:removed', =>
      window.displayMode.updateMode('view', false)
      @refresh()
    @filters = ["folder", "categories", "sort", "search"]

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = window.contactsRouter.getParam filter
    @params

  bindings: =>
    super   #    lxkuz, pagination
    @destroyContactLink = $('a.destroy-contact', @el).click @destroyContact
    @messageContactLink = $('a.message-contact', @el).click @messageContact
    @taskContactLink = $('a.task-contact', @el).click @taskContact
    @contacts = $ "li.contact-list-item", @el
    @contacts.on "click", ":not(.actions, .trigger, i.icon-reorder)", @showContact

  router: =>
    window.contactsRouter

  showContact: (e) =>
    $target = $ e.target
    $target.closest('li').addClass('active').siblings().removeClass('active')
    contactId = $target.closest('.person').data('contact-id') or $target.attr('href').split('/')[1]
    searchInput = $ '#search', '.search'
    searchInput.val('') if searchInput
    window.contactsRouter.navigate "contacts/#{contactId}", true
    window.displayMode.enableMode('view')

  createContact: (e) =>
    e.preventDefault()

    form = $ e.target
    $.ajax(url: form.attr('action'), data: form.serialize(), type: 'POST', dataType: 'json').done (res) =>
      unless _.any(res.errors)
        @refresh '/contacts', =>
          link_to = _.template('<a href="/contacts/<%= id %>"><%= fullName %></a>')
          form.find('button').attr('disabled', 'disabled').toggleClass('plus ok').find('icon').toggleClass('icon-plus icon-ok')
          fullName = form.find('.name').text()
          form.find('.name').html(link_to(id: res.id, fullName: fullName)).parents('li').addClass('contact-exists')
          contact = @el.find(".person[data-contact-id=#{res.id}]")
          contact.parent().hide().fadeIn "slow" if contact

  destroyContact: (e) =>
    e.preventDefault()
    if confirm app.i18n.t('components.widgets.contacts.list.are_you_sure')
      link = $(e.target).attr('href')
      contactId = parseInt(link.match(/\d+$/))
      contactEl = $(".person[data-contact-id=#{contactId}]", @el).parents('li')
      $.ajax(url: link, type: 'DELETE').done (data) =>
        if data
          contactEl.fadeOut('slow')
          window.displayMode.updateMode('view', false)
        else
          alert app.i18n.t('components.widgets.contacts.list.errors_when_remove')

  messageContact: (ev)=>
    ev.stopPropagation()

  taskContact: (ev)=>
    ev.stopPropagation()
#    linkUrl = $(ev.currentTarget).attr "href"

  refresh: (path, cb) =>
    @active = false
    $.ajax(url: (path or @url or '/contacts'), data: @getParams()).done (data) =>
      @draw(data)
      cb?(data)

app.initializer.addComponent "ContactsList", "contacts-list-column", (obj) ->
  window.contactsList = obj
