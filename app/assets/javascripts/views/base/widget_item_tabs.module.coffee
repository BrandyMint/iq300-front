Widget = require 'views/base/widget'

class WidgetItemTabs extends Widget
  init: =>
    super
    @activateTab $('.tabnav', @el).data 'active-tab'

  activateTab: (activeTab)=>
    return false unless activeTab
    tabs = $ '.tabnav', @el
    tab = $ "> .#{activeTab}", tabs
    if tab.length > 0
      setTimeout =>
        $("a", tab).click()
      ,0
    else
      $(".#{activeTab}", @el).ScrollTo()

  bindings: =>
    @tabs = $('.tabnav', @el)
    app.initializers.TabNav(@el)

  refresh: (callback=undefined)=>
    tab = @tabs.find('li.active a').data('target')
    $.ajax
      url: @getUrl()
      data: @getParams()
      beforeSend: =>
        @active = false
        @el.addClass('is-loading')
      error: window.errorHandler
      success: (data) =>
        @draw(data)
        callback?()
        window.displayMode.bindings()
        if tab
          @el.find('.object-details').hide()
          @tabs.find('li').removeClass('active')
          @tabs.find("li a[data-target=#{tab}]").trigger('click')
      complete: =>
        @el.removeClass('is-loading')
        @onRefreshComplete()

module.exports = WidgetItemTabs
