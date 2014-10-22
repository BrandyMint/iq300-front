window.NewProject ||= {}

((app) ->
  $(document).ready ->

    stepSwitcher = $('@step-switcher')
    stepInformer = $('@step-informer')
    stepIndicator = $('@step-indicator')
    stepForm = $('@form-step')
    backBtn = $('@step-back-btn')
    projectTeamList = $('@team-list')

    select2btn = $('@projects-form-select2btn')

    stepSwitcher.on 'click', (e) ->
      e.preventDefault()
      step = $(@).data('step')
      setStepAll step
    
    stepIndicator.on 'click', (e) ->
      e.preventDefault()
      step = $(@).data('step')
      setStepAll step

    backBtn.on 'click', (e) ->
      e.preventDefault()
      target = $(@).data('target')
      setStepAll target

    select2btn.on 'click', (e) ->
      e.preventDefault()
      $('#select2-drop-mask').show()
      $('#select2-drop').show()

    setStepAll = (step) ->
      if step?
        setStep step
        setStepInformer step
        setBackBtn step
    
    setStepInformer = (step) ->
      stepInformer.find('@step-indicator').removeClass('active')
      stepInformer.find('@step-indicator[data-step="'+step+'"]').addClass 'active'

    setStep = (step) ->
      stepForm.hide()
      stepForm.filter('[data-step="'+step+'"]').show()

    setBackBtn = (step) ->
      backBtn.hide()
      backBtn.filter('[data-step="'+step+'"]').show()


    goalsEditor = $('@projects-form-goal-editor')
    goalsEditorInput = goalsEditor.find('textarea')
    addGoalBtn = $('@projects-form-add-project-goal')
    goalsList = $('@projects-form-goals-list')
    closeGoalsEditor = goalsEditor.find('@save-button, @cancel-button, @delete-button')

    addGoalBtn.on 'click', (e) ->
      e.preventDefault()
      goalsEditor.show()

    closeGoalsEditor.on 'click', (e) ->
      e.preventDefault()
      goalsEditor.hide()
      goalsEditorInput.val('')

    goalsList.find('li').on 'click', () ->
      text = $(@).text()
      goalsEditor.show()
      goalsEditorInput.val(text)


    projectTeamAddCommunity = $('@add-another-community')
    projectTeamCommunitySelect = $('@project-team-select-community')

    projectTeamAddCommunity.on 'change', () ->
      titles = $(@).val()
      last_option = projectTeamCommunitySelect.last()
      for title in titles
        #btn_html = '<a class="btn btn-link btn-sm" href="#">' + title + '</a>'
        #$(btn_html).insertBefore(first_btn)
        option_html = '<option>' + title + '</option>'
        $(option_html).insertAfter(last_option)

    #projectMemberCheckbox = $('@project-team-member-checkbox input')
    projectMemberCheckboxBtn = $('@project-team-member-checkbox-admin')
    projectMemberCheckboxBtn.on 'click', (e) ->
      e.preventDefault()
      $(@).toggleClass 'active'


)(window.NewProject ||= {})

((app) ->
  $(document).ready ->
    select2multiple = $('@select2-multiple')
    select2multiple.select2()
)(window.NewProject ||= {})


