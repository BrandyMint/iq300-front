window.TaskForm ||= {}

((app) ->
  $(document).ready ->
    toggle = $('@task-new-checklist-type')
    weightField = $('@task-todo-weight')
    checkToggle(toggle, weightField)
    toggle.on 'change', (e) ->
      checkToggle(toggle, weightField)

  checkToggle = (toggle, weightField) ->
    if toggle.filter(':checked').val() == "true"
      weightField.show()
    else
      weightField.hide()


)(window.TaskForm ||={} )
