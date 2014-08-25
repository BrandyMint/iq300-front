#= require jquery/dist/jquery
#= require bootstrap
#= require jquery.role/lib/jquery.role

$ ->
  $('@tooltip').tooltip()

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

  $('@project-tasks-list-select-all').on 'change', () ->
    checkboxes = $('.project-task-box input[type="checkbox"]')
    checkboxes.prop('checked', !checkboxes.prop('checked'))

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

