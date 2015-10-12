#= require jquery/dist/jquery
#= require bootstrap
#= require jquery.role/lib/jquery.role
#= require modernizr/modernizr
#= require select2/select2
#= require momentjs/moment
#= require momentjs/locale/ru
#= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
#= require jquery-autosize/jquery.autosize.min
#= require Caret.js/dist/jquery.caret.min
#= require jquery.atwho/dist/js/jquery.atwho.min
#= require bootstrap-multiselect/dist/js/bootstrap-multiselect
#= require fullcalendar/dist/fullcalendar
#= require jquery-drag-drop-plugin/jquery.drag-drop.plugin
#= require purl/purl
#= require layout
#= require projects/tasks
#= require projects/new
#= require projects/discussions
#= require projects/list
#= require projects/milestones
#= require projects/wizard
#= require notifications/list
#= require notifications/widget
#= require tasks/list
#= require tasks/form
#= require tasks/checklist
#= require communities/billing
#= require layout/fixed_block
#= require discussions/mention
#= require calendar/calendar
#= require comments/form
#= require contacts/list
#= require conversations/conference

$ ->
  $('@select2').select2()
  $('@multiselect').multiselect()
  $('[data-toggle*="popover"]').popover()
  multiselectTaskStates = $('@multiselect-task-states')
  multiselectTaskStates.multiselect
    includeSelectAllOption: true
    selectAllText: 'Все задачи'
    buttonText: (options, select) ->
      if options.length is 0 || options.length is multiselectTaskStates.find('option').length
        "<i class=\"fa fa-list\"></i>&nbsp; Все задачи <b class=\"caret\"></b>"
      else
        labels = []
        options.each ->
          labels.push $(@).text()
        labels.join(", ") + " "

  multiselectUsers = $('@multiselect-users')
  multiselectUsers.multiselect
    maxHeight: 200
    includeSelectAllOption: true
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    selectAllText: 'Все исполнители'
    buttonText: (options, select) ->
      if multiselectUsers.find('option:selected').length is 0 || multiselectUsers.find('option:selected').length is multiselectUsers.find('option').length
        "<i class=\"fa fa-user\"></i>&nbsp; Все исполнители <b class=\"caret\"></b>"
        #else if options.length is 0
        #"<i class=\"fa fa-user\"></i> Все"
      else
        "<i class=\"fa fa-user\"></i>&nbsp; Исполнители: " + options.length + " <b class=\"caret\"></b>"

  $('@datetimepicker').datetimepicker
    locale: 'ru'
    icons:
      time: "fa fa-clock-o datetimepicker-icon",
      date: "fa fa-calendar datetimepicker-icon",
      up: "fa fa-angle-up datetimepicker-icon",
      down: "fa fa-angle-down datetimepicker-icon"
      previous: 'fa fa-angle-left datetimepicker-icon'
      next: 'fa fa-angle-right datetimepicker-icon'
    format: 'DD/MM/YYYY HH:mm'

  $('@datetimepicker-now').datetimepicker
    locale: 'ru'
    defaultDate: moment()
    icons:
      time: "fa fa-clock-o datetimepicker-icon",
      date: "fa fa-calendar datetimepicker-icon",
      up: "fa fa-angle-up datetimepicker-icon",
      down: "fa fa-angle-down datetimepicker-icon"
      previous: 'fa fa-angle-left datetimepicker-icon'
      next: 'fa fa-angle-right datetimepicker-icon'
    format: 'DD/MM/YYYY HH:mm'


  $('@datetimepicker input').on 'focus', () ->
    picker = $(@).parents().find('[role*="datetimepicker"]').first()
    picker.data("DateTimePicker").date(moment())
    picker.data('DateTimePicker').show()

  $('@tooltip').tooltip
    container: 'body'

  $('@autosize').autosize()

  @checkboxes = $('.project-task-box input[type="checkbox"], @project-tasks-list-select-all')

  $('@project-group-header').on 'click', () ->
    $(@).find('@project-group-header-form')
      .removeClass('hide')
      .find('input').first().focus()
    $(@).find('@project-group-header-content').addClass('hide')

  $('@project-group-header-form-close').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(@).parents('@project-group-header-form').addClass('hide')
    $(@).parents('@project-group-header').find('@project-group-header-content').removeClass('hide')

  $('@project-tasks-list-toggle-groups').on 'change', () ->
    $('@project-tasks-list').toggleClass('project-tasks-list-show-groups')
    $('@project-group-header').toggleClass('hide')

  $('@project-tasks-list-select-all').on 'change', () =>
    @checkboxes.prop('checked', !@checkboxes.prop('checked'))

  @checkboxes.on 'change', () =>
    if @checkboxes.is(':checked')
      $('@project-group-header-actions').removeClass('hide')
    else
      $('@project-group-header-actions').addClass('hide')

  $('@project-tasks-list-add-task-btn').on 'click', (e) ->
    e.preventDefault()
    $('@project-tasks-list-new-task')
      .removeClass('hide')
      .find('input').first().focus()


  $('@project-tasks-list-task-form-close').on 'click', (e) ->
    e.preventDefault()
    $('@project-tasks-list-new-task').addClass('hide')

  $('@project-task-box-edit-task-btn').on 'click', (e) ->
    e.preventDefault()
    project_id = $(@).data('project-id')
    $('@project-task-box[data-project-id*="'+project_id+'"]').addClass('hide')
    $('@project-task-box-form[data-project-id*="'+project_id+'"]').removeClass('hide')
    if project_id == 'new'
      $(@).hide()
      $('@project-task-box-form-close').filter('[data-project-id="new"]').show()
      $('@project-task-box-template-form').addClass 'hide'

  $('@project-task-box-form-close').on 'click', (e) ->
    e.preventDefault()
    project_id = $(@).data('project-id')
    $('@project-task-box[data-project-id*="'+project_id+'"]').removeClass('hide')
    $('@project-task-box-form[data-project-id*="'+project_id+'"]').addClass('hide')
    if project_id == 'new'
      $(@).hide()
      $('@project-task-box-edit-task-btn').filter('[data-project-id="new"]').show()
      $('@project-task-box-template-form').removeClass 'hide'



  docsFiltersToggle = $('@documents-filters-toggle')
  docsContentGlobal = $('@documents-content-global')
  docsFiltersToggle.on 'click', (e) ->
    e.preventDefault()
    view = docsContentGlobal.attr('view')
    if view == 'true'
      docsContentGlobal.attr('view', '')
    else
      docsContentGlobal.attr('view', 'true')

$(document).on 'click', '@jump', (e) ->
  href = $(this).data('href')
  if $(this).data 'push'
    window.wiselinks.load href
  else
    if href != ''
      if event.shiftKey || event.ctrlKey || event.metaKey
        window.open(target, '_blank')
      else
        window.location = href

$(document).on 'click', '@jump .dropdown, @jump input', (e) ->
  e.stopPropagation()
