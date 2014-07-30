WidgetList = require 'views/base/widget_list'

class window.DocumentsList extends WidgetList
  init: =>
    @filters = ["folder", "categories", "community", "sort", "search"]
    @shareLinkPopup = $ '.share-link-popup'
    @closePopupBtn = $ '.close', @shareLinkPopup
    @closePopupBtn.click @hideSharePopup
    @closeFoldersBtn = $ '.top-panel a.close-folders'
    @closeFoldersBtn.click @closeAllFolders

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    folder = @router().getParam("folder")
    if folder == undefined || folder == 'my'
      @router().setParam "folder", "roots,my"
    for filter in @filters
      @params[filter] = @router().getParam filter
    @params

  getParamsStr: =>
    str=''
    for key, value of @getParams()
      str += "#{key}=#{value}&" unless value == undefined
    str


  bindings: (el=@el)=>
    super
    if el.length == 1 && !$(el[0]).hasClass('doc-item')
      docs = $ ".doc-item", el
      activeEl = $ ".doc-item.active", el
      @activeLine = activeEl.data "id" if activeEl
    else
      docs = el.filter '.doc-item'
    for doc in docs
      @docBindings $ doc

  docBindings: (doc)=>
    doc.click @showDocument
    doc.bind 'mouseenter mouseleave', @onHover
    folder = $ "a.folder", doc
    folder.click @toggleFolder
    popup = $ '.actions', doc
    popup.bind 'popup:shown', @hidePopups
    actionLinks = $ '.actions .context-menu a', doc
    actionLinks.click @doAction
    editor = $ 'span.best_in_place', doc
    editor.best_in_place()



  draw: (response)=>
    unless @isActive()
      data = $ response
      $('.spinner-box', @el).remove()
      if @params
        if @params.page == 1
          @page = 1
          @lastPage = false
          @infiniteList.empty()
          @infiniteList.append(data)
        else if (response + '').length == 0
          @lastPage = true
        else
          @infiniteList.append data
        @bindings data
        app.initializer.initializeOnly "Popup", @infiniteList
        @loading = false


  doAction: (ev)=>
    ev.stopPropagation()
    link = $ ev.currentTarget
    link.parents('.actions').find(' > a.menu i').click()
    if link.hasClass 'delete'
      return @destroyDoc ev, link
    if link.hasClass 'rename'
      return @activateInput ev, link
    if link.hasClass 'share'
      return @showSharePopup link.attr 'href'
    if link.hasClass 'download'
      return true
    if link.hasClass 'recover'
      return @recoverDoc ev, link

  activateInput: (event, link)=>
    event.preventDefault()
    target = $ link.data("target"), @el
    target.trigger "click"
    window.displayMode.disableMode("view")
    false

  onHover: (ev)=>
    ev.stopPropagation()
    $('li.doc-item', @el).removeClass "hovered"
    if ev.type == "mouseenter"
      $(ev.currentTarget).addClass "hovered"

  destroyDoc: (event, link)=>
    event.preventDefault()
    event.stopPropagation()
    confirmText = link.data 'confirm'
    if confirm(confirmText)
      $.ajax
        url: link.attr 'href'
        method: 'DELETE'
        dataType: 'json'
        success: (response)=>
          link.closest('.doc-item').remove()
          window.displayMode.disableMode("view")
        error: window.errorHandler
    false

  recoverDoc: (event, link)=>
    event.preventDefault()
    event.stopPropagation()
    $.ajax
      url: link.attr 'href'
      method: 'PUT'
      dataType: 'json'
      success: (response)=>
        link.closest('.doc-item').remove()
        window.displayMode.disableMode("view")
      error: window.errorHandler
    false

  router: =>
    window.documentsRouter

  list: =>
    window.documentsList

  view: =>
    window.documentView

  toggleFolder: (ev)=>
    ev.stopPropagation()
    target = $ ev.currentTarget
    @_toggleFolder target

  _toggleFolder: (opener, folder=null)=>
    url = opener.data 'url'
    folder = opener.closest('li') unless folder
    folder.toggleClass('is-open')
    $(window).trigger 'docs-folder-changed', [folder.data('id'), folder.data('communityId')]
    unless folder.hasClass 'loaded'
      @loadFolderChildren folder, url
    false


  loadFolderChildren: (folder, url)=>
    nestedList = $ ' > ul.nested-list', folder
    nestedList.append("<div class='spinner-box is-loading'></div>")
    $.ajax
      url: url
      data: @getParams()
      type: "GET"
      success: (response)=>
        data = $ response
        nestedList.html data
        app.initializer.initializeOnly "Popup", @el
        @bindings data
        parent = nestedList.parent()
        parent.addClass 'loaded'
        nestedList.addClass "nesting-level-#{parent.parents('ul.nested-list').length + 1}"

  closeAllFolders: =>
    docs = $ ".doc-item", @el
    docs.removeClass "is-open"

  toggleContextMenu: (ev)=>
    target = $ ev.currentTarget
    target.parent().toggleClass 'shown'
    false

  showSharePopup: (text)=>
    input = $('input', @shareLinkPopup)
    input.val(text)
    @shareLinkPopup.addClass 'shown'
    input.select()
    false

  hideSharePopup: =>
    @shareLinkPopup.removeClass 'shown'

  clearSelection: =>
    docs = $ ".doc-item", @el
    docs.removeClass "active"

  setShareLink: =>


  showDocument: (ev)=>
    ev.stopPropagation()
    @hideSharePopup()
    popups = $ '.actions', @el
    popups.removeClass 'shown'
    target = $ ev.currentTarget
    if target.hasClass 'is-folder'
      ev.preventDefault()
      @clearSelection()
      opener = $ '> .opener > a.folder', target
      @_toggleFolder opener, target
      return false

    if target.hasClass 'active'
      target.removeClass "active"
      window.displayMode.disableMode("view")
      return false

    @clearSelection()
    target.addClass "active"
    @activeLine = target.data "id"
    url = "docs/#{@activeLine}?#{@getParamsStr()}"
    folder = @router().getParam('folder')
    searchInput = $ '#search', '.search'
    searchInput.val('') if searchInput
    @router().navigate url, true
    window.displayMode.enableMode("view")
    popups = $ '.actions.active', @el
    popups.removeClass 'shown'
    false

  hidePopups: (ev)=>
    @hideSharePopup()
    popups = $ '.actions', @el
    popups.removeClass 'active'
    $(ev.currentTarget).addClass 'active'
    popups = $ '.actions:not(.active)', @el
    popups.removeClass 'shown'


app.initializer.addComponent "DocumentsList", 'folders-list-column', (obj)=>
  window.documentsList = obj
