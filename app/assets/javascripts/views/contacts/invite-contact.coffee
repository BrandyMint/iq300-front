class window.InviteContactView
  constructor: (el) ->
    @el = $(el)
    @form = $('form', @el)
    @form.submit(@invite)

  invite: =>
    @el.addClass('is-loading')
    $.ajax
      url: @form.attr('action')
      data: @form.serialize()
      dataType: 'json'
      type: 'POST'
      success: @refresh
      error: (xhr)=>
        window.errorHandler xhr, true, =>
          @el.removeClass('is-loading')
    false

  refresh: =>
    @el.removeClass('is-loading')
    @form.find('input[type="submit"]').attr('value', app.i18n.t('common.invite_sent')).css('background-color', '#1abc9c')
    _.delay =>
      @form.find('input[type="submit"]').attr('value', app.i18n.t('components.widgets.contacts.invite.send_invitation')).css('background-color', '#399abd')
      @form.find('input[type="email"]').attr('value', '').attr('placeholder', app.i18n.t('components.widgets.contacts.invite.enter_email'))
    , 1000

app.initializer.addComponent 'InviteContactView', 'invite-contact', (obj) ->
  window.inviteContactView = obj
