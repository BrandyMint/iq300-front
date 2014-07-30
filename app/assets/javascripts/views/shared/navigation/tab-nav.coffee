class window.TabNav

  constructor: (el) ->
    @el = $ el
    @template = _.template('<div id="<%= id %>" class="<%=style%>" data-url="<%=url%>"><%= data %></div>')
    @links = $('li:not(.not-initialize) a', @el).on('click', @show)

  show: (e) =>
    e.preventDefault()
    $(window).trigger 'new-tab'
    @container = $(@el.data('container'))
    @link = $(e.target)
    targetEl = @link.data('target')
    if targetEl
      $(window).trigger "new-tab:#{targetEl}"
      if @link.data('full-view')
        $(window).trigger "set-mode:full-view"
    if (@target = $('#' + @link.data('target'))).length
      @activate()
    else
      @container.addClass('is-loading')
      $.ajax
        url: @link.attr('href')
        success: (data) =>
          @container.append(@template(id: @link.data('target'), style: "object-details #{@link.data('target')}-tab #{@link.data('class')}", url: @link.attr('href'), data: data))

          app.initializer.initialize(@target = $('#' + @link.data('target')))
          app.initializer.initialize @target.parent()
          @activate()
        error: window.errorHandler
        complete: =>
          @container.removeClass('is-loading')

  activate: =>
    @container.children().hide()
    @link.parent('li').addClass('active').siblings().removeClass('active')
    @target.show()

app.initializers.TabNav = (el) ->
  window.tabNavs or = []
  elems = $(el).find "[role='tabnav']"
  for elem in elems
    window.tabNavs.push(new TabNav(elem))
    $(elem).removeAttr("role").attr "role-ready", "tabnav"
