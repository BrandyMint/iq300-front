window.Crm ||= {}

((app) ->
  $(document).ready ->
    $crm = $('@crm-app')
    $container = $('@application-content-wrapper')
    $crm.appendTo $container

    $dealProgress = $('@deal-progress-bar')
    $dealProgress.on 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
    $dealDone = $('[role-deal-progress-final="true"]')
    $dealDone.each ->
      pop = app.popover(@)
    $dealDone.on 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()

  app.popover = (el) ->
    pop = $(el).popover
      content: '<div>
          <div class=\"content-group-sm\">
            Выберите результат, с которым закрыта сделка
          </div>
          <div class=\"content-group-sm text-center\">
            <a class=\"btn btn-success\">
             Сделка заключена
            </a>
          </div>
          <div class=\"content-group-sm text-center\">
            <a class=\"btn btn-danger\">
             Сделка проиграна
            </a>
          </div>
        </div>'
      template: "<div class=\"popover fade\">
          <div class=\"arrow\"></div>
            <div class=\"popover-content\">
            </div>
        </div>"
      title: false
      html: true
      placement: 'bottom'
      trigger: 'click',
      container: '[role="application-content-block"]'
    return pop


)(window.Crm ||= {})
