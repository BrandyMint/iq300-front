$ ->
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

  $('@project-task-box-form-close').on 'click', (e) ->
    e.preventDefault()
    project_id = $(@).data('project-id')
    $('@project-task-box[data-project-id*="'+project_id+'"]').removeClass('hide')
    $('@project-task-box-form[data-project-id*="'+project_id+'"]').addClass('hide')


window.ProjectTasksList ||= {}

((app) ->
  $(document).ready ->
    $statusBlock = $('@project-task-box-status-block')
    $body = $('body')
    $statusBlock.on 'click', (e) ->
      if $(@).data('bs.popover')?.$tip?.length > 0
        $body.find('td').each ->
          $(@).popover('destroy')
      else
        $body.find('td').each ->
          $(@).popover('destroy')
        e.preventDefault()
        e.stopPropagation(e)
        app.pop = app.popover $(@), $(@).parent()
        $popover = app.pop.data('bs.popover')
        app.pop.popover('show')
        $popover.$tip.find('input[type="datetime"]').val(moment().format('DD/MM/YYYY HH:mm'))
        $popover.$tip.find('input[type="datetime"]').datetimepicker
          keepOpen: false
          #language: 'ru'
          icons:
            time: "fa fa-clock-o datetimepicker-icon",
            date: "fa fa-calendar datetimepicker-icon",
            up: "fa fa-arrow-up datetimepicker-icon",
            down: "fa fa-arrow-down datetimepicker-icon"
          format: 'DD/MM/YYYY HH:mm'
          #$popover.$tip.find('input:first').focus()

  app.popover = (el, container) ->
    pop = $(el).popover
      template: '<div class="popover-form-block" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        </div>'
      content: '<form class="form form-vertical popover-form">
          <label class="popover-form-content-block">
            Выполнить к
          </label>
          <input class="popover-form-control" type="datetime">
        </div>
        <div class="popover-form-actions">
          <a href="" class="popover-form-submit-btn">сохранить</button>
        </form>'
      html: true
      placement: 'top'
      trigger: 'manual'
      container: container
    return pop

)(window.ProjectTasksList ||= {})
