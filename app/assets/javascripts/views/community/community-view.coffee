WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.CommunityViewColumn extends WidgetItemTabs
  init: =>
    super
    @id = @el.data 'id'
    @communityTitle = $('.with-icons', @el).text()
    @actionLinks = $ "a[data-role='action']", @el

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
          @refresh()
          new window.Flash("#{app.i18n.t('components.widgets.community-form.you_are_leave')} \u00AB#{@communityTitle}\u00BB")
        error: window.errorHandler

  show: (id)=>
    @id = id
    @empty = false
    @notFirstTime = true
    @refresh =>
      @changeChannel()

  getUrl: =>
    regexp = /\/\d*$/
    if @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"
    @url

  bindings: =>
    super
    @tabUrls = $ "header.tab-navigation ul.tabnav li", @el
    @tabUrls.click @showTab
    @actionLinks.bind 'click', @processAction

  showTab: (ev) =>
    target = $ ev.currentTarget
    link = $ 'a', target
    window.communitiesRouter.navigate link.attr('href'), true

app.initializer.addComponent "CommunityViewColumn", "community-view-column", (item)->
  window.communityViewColumn = item
