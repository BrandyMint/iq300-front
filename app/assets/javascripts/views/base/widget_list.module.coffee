Widget = require 'views/base/widget'

class WidgetList extends Widget
  SCROLL_AREA_HEIGHT: 15

  config:
    withButton: false
    moreBtnDataClass: 'more-button-data'
    itemsOnPage: ''

  constructor: (el, options={})->
    @bindedToSorting = false
    @bindedToSearch = false
    @bindedToViewClose = false
    @bindedToExternalScroll = false

    super(el, options)

  init: =>
    @withButton = @el.data('with-button') != undefined
    @setDefaultPage()
    @newElements = $ ".new-elements", @el
    @newElements.hide()
    @loading = false

    if @withButton
      @moreButtonContainer = $ JST['templates/infinite_list_button']({btnLimitValue: @config.itemsOnPage})
      @moreButton = $ '.infinite-list-button', @moreButtonContainer
      @moreButtonVal = @moreButton.html()

      @el.append @moreButtonContainer
    else
      if @el.data('list-with-scroll')
        @getInfiniteList().scroll @onScroll
      else
        @el.scroll @onScroll

  isLoading: =>
    @loading

  getInfiniteList: =>
    @infiniteList or $ '.infinite-list', @el

  bindings: =>
    # now we need use 'super' method into childrens
    unless @bindedToViewClose
      @bindedToViewClose = true
      $(window).bind "view:false", @clearSelection
    scrollContainerSelector = @el.data 'scroll-container'
    @scrollContainer =  $ scrollContainerSelector  if scrollContainerSelector && !@scrollContainer
    if !@bindedToExternalScroll && @scrollContainer
      @bindedToExternalScroll = true
      @scrollContainer.scroll @onScroll unless @withButton

    @infiniteList = @getInfiniteList()

    @moreButton.bind 'click', @nextPage if @config.withButton
    @newElements = $ ".new-elements", @el
    @newElements.unbind 'click'
    @newElements.click @refreshNewElements
    if !@bindedToSearch && window.searchForm
      @bindedToSearch = true
      window.searchForm.onSearch = (event, params) =>
        @setParamAndRefresh('search', params) if @el.is(':visible')

    @listHeader ||= $ ".header", @el
    unless @bindedToSorting
      @bindedToSorting = true
      @listHeader.on 'sort', (event, params)=>
        @setDefaultPage()
        @setParamAndRefresh 'sort', params

  watch: (data)=>
    if !@empty && !@isActive()
      @refreshInQueue = false
      @setDefaultPage()
      @refresh(data)
    else
      unless @refreshInQueue
        @refreshInQueue = true
        setTimeout @watch, 5000
    if  @newElements
      @newElements.first().show()

  refreshNewElements: =>
    @setDefaultPage()
    @setParamAndRefresh 'sort', '-id'
    @newElements.hide()

  draw: (response)=>
    unless @isActive()
      data = $ response
      @initializeData data
      if @withButton
        @moreButton.html(@moreButtonVal)
        @moreButton.removeClass('is-loading')
      else
        $('.spinner-box', @el).remove()
      if @params
        if @params.page == 1
          @page = 1
          @lastPage = false
          @infiniteList.empty()
          @infiniteList.append(data)
          if @withButton
            @parseDataAndAddMoreBtn(data, 1)
        else if (response + '').length == 0
          @lastPage = true
          @moreButton.remove() if @withButton
        else
          if @withButton
            @parseDataAndAddMoreBtn(data, @params.page)
          else
            @infiniteList.append(data)
        @bindings()
        @loading = false

  initializeData: (data)=>
    app.initializer.initialize data

  setParamAndRefresh: (param, value)=>
    @setDefaultPage()
    if value
      @router().setParam param, value
    else
      @router().deleteParam param
    @active = false
    @refresh()

  nextPage: =>
    unless @isLoading()
      @active = false
      @loading = true
      @page = @page || 1
      @params = @params || {}
      unless @lastPage
        @page += 1
        @params.page = @page
        if @withButton
          @moreButton.html('')
          @moreButton.addClass('is-loading')
        else
          @infiniteList.append("<div class='spinner-box is-loading'></div>")
        @refresh(undefined, false)
    false

  setDefaultPage: =>
    @page = 1
    @params = @params || {}
    @params.page = @page

  clearSelection: =>
    # template method

  onScroll: (ev)=>
    scrollContainer = $ ev.currentTarget
    if scrollContainer.scrollTop() + scrollContainer.innerHeight() >= scrollContainer[0].scrollHeight - @SCROLL_AREA_HEIGHT
      @nextPage() if @el.is(':visible')

  parseDataAndAddMoreBtn: (data, page)=>
    btnData = null
    _.each data, (item)=>
      $element = $ item
      if $element.hasClass(@config.moreBtnDataClass)
        btnData = @moreBtnDataOptions($element)

    if page == 1
      @el.append @moreButtonContainer
      @moreButton.html(@moreButtonVal)
    else
      @moreButton.parent().before(data)

    @moreButton.remove() unless @isNeedMoreBtn(btnData)

  moreBtnDataOptions: ($element)=>
      totalPages: $element.data('total-pages')
      currentPage: $element.data('current-page')
      limitValue: $element.data('limit-value')

  isNeedMoreBtn: (btnData)=>
    return false unless btnData
    btnData.totalPages && btnData.currentPage && btnData.totalPages > btnData.currentPage

module.exports = WidgetList