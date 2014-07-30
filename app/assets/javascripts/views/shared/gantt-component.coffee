Widget = require 'views/base/widget'

class window.GanttComponent extends Widget
  init: =>
    @url = @el.data "url"
    @skipBeforeLinkAddEvent = false
    @linksUrlTemplate = @el.data 'linksUrlTemplate'
    @readonly = !@el.data("can-edit")
    IQ300.Plugin.use 'gantt', @initGantt
    $(window).bind "new-tab:task_gantt", @refresh
    $(window).bind "resize", @setHeight

  initGantt: =>
    gantt.config.select_task = !@readonly
    gantt.config.drag_links = !@readonly
    gantt.config.drag_progress = false
    gantt.config.drag_resize = false
    gantt.config.drag_move = false
    gantt.config.details_on_dblclick = false
    gantt.config.initial_scroll = false
    gantt.config.grid_width = 0
    gantt.config.xml_date = app.i18n.t('components.gantt_component.xml_date_format')
    gantt.config.columns = [
      # name: "text"
      # label: "Задача"
      # width: "*"
      # tree: true
      # width: 220
      # ,
      # name: "owner"
      # label: "Назначена"
      # template: (obj) ->
      #   if obj.holder is `undefined`
      #     ""
      #   else
      #     obj.holder
      # 
      # align: "center"
      # width: 80
    ]
    gantt.templates.task_class = (start, end, obj) ->
      css = obj.status
      css += ' mailstone' unless obj.parent
      css
    gantt.templates.scale_cell_class = (date) ->
      css = ''
      css += "weekend" if date.getDay() is 0 or date.getDay() is 6
      css += " current" if gantt.date.date_part(date).valueOf() == gantt.date.date_part( new Date()).valueOf()
      css
    gantt.templates.task_cell_class = (item, date) ->
      "weekend"  if date.getDay() is 0 or date.getDay() is 6
    gantt.templates.tooltip_text = (start, end, task) ->
      content = "<b>" + task.text + "</b><br/>"
      content += "<b>#{gantt.locale.labels.executor}:</b> #{task.holder}<br/>"
      content = content + "<div><b>" + gantt.locale.status[task.status] + "</b></div>"  if (gantt.locale.status[task.status] isnt `undefined`) or (gantt.locale.status[task.status] isnt "")
      content + "<b>" + gantt.locale.labels.start_date + ":</b> " + gantt.templates.tooltip_date_format(start) +
      "<br/>" + "<b>" + gantt.locale.labels.end_date + ":</b> " + gantt.templates.tooltip_date_format(end)

    gantt.attachEvent "onBeforeLinkAdd", @saveLink
    gantt.attachEvent "onBeforeLinkDelete", @destroyLink

    gantt.config.readonly = @readonly
    @el.css 'height', '70px'
    gantt.init(@el[0])
    # @hideLeftColumn()
    @refresh()

  linksUrl: (taskId, linkId=undefined)=>
    url = @linksUrlTemplate.replace ":task_id", taskId
    url += "/#{linkId}" if linkId
    url

  saveLink: (linkId, link)=>
    return false if @readonly
    if @skipBeforeLinkAddEvent
      @skipBeforeLinkAddEvent = false
      return true
    $.ajax
      url: @linksUrl(link.target)
      data:
        task_relation:
          source_task_id: link.source
      type: "POST"
      dataType: "json"
      success: (response)=>
        gantt._deleteLink linkId, true
        @skipBeforeLinkAddEvent = true
        newLink = response.task_relation
        gantt.addLink newLink
      error: (response)=>
        window.errorHandler response, true, =>
          gantt._deleteLink linkId, true

  destroyLink: (linkId, link)=>
    return false if @readonly
    $.ajax
      url: @linksUrl(link.target, link.id)
      data:
        _method: 'delete'
      type: "POST"
      dataType: "json"
      error: window.errorHandler



  setHeight: =>
    footerHeight = 30
    @el.css 'height', "#{$(window).height() - @el.offset().top - footerHeight}px"
    gantt.setSizes()

  hideLeftColumn: =>
    # $(".gantt_grid", @el).css "display", "none"
    # $(".gantt_task", @el).css "width", "100%"

  refresh: =>
    @el.addClass 'is-loading'
    $.ajax
      url: @url
      type: "GET"
      success: @draw
      error: window.errorHandler
      complete: =>
        @el.removeClass 'is-loading'

  draw: (response)=>
    unless @isActive()
      @setHeight()
      gantt.clearAll()
      gantt.parse response
      gantt.scrollTo gantt._pos_from_date( new Date()) - 50
      # @hideLeftColumn()

app.initializer.addComponent 'GanttComponent', 'gantt-component',  (obj)=>
  window.ganttChart = obj
