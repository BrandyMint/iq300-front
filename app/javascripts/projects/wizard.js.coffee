window.ProjectWizard ||= {}

((app) ->
  $(document).ready ->
    $('@project-wizard-backdrop').show()
    $('@project-wizard-next-btn').on 'click', (e) ->
      e.preventDefault()
      step = $(@).data('step')
      stepBlock = $('@project-wizard-step-block').filter ->
        $(@).data('step') == step
      $('@project-wizard-step-block').hide()
      stepBlock.show()

)(window.ProjectWizard ||= {})
