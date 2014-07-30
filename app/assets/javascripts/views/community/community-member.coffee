Widget = require 'views/base/widget'

class window.CommunityMember extends Widget

  init: =>
    super
    @memberName = $('.name > a', @el).text()

  bindings: =>
    super
    @actionLinks = $ "a[data-role='action']", @el
    @actionLinks.click @processAction

  processAction: (ev)=>
    ev.preventDefault()
    link = $ ev.currentTarget
    url = link.prop "href"
    confirm = window.confirm link.data('confirmation')
    if confirm
      @el.addClass('is-loading')
      $.ajax
        url: url
        method: 'POST'
        success: =>
          @el.fadeOut 'normal', =>
            @el.remove()
          new window.Flash(@flashText())
        error: window.errorHandler

  flashText: =>
    text = "#{app.i18n.t('components.widgets.community-member.member')} #{@memberName} "
    text = text + app.i18n.t('components.widgets.community-member.deleted')

app.initializer.addComponent 'CommunityMember'