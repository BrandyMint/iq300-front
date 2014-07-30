StepManager = require '/views/forms/step_manager'
TeamEditor = require '/views/forms/team_editor'
InputsManager = require('views/projects/form/inputs_manager/inputs_manager')

class window.ProjectsForm
  config:
    communityInputSelector: '[name="project[community_id]"]'
    teamElementSelector: '[role=team-editor]'
    inputsManager: '[role=inputs-manager]'
    focusableInputsSelector: 'input[type=text]'

  constructor: (el)->
    @$el = $ el

    @_setUi()
    @bindings()
    @_initStepManager()
    @_initTeamEditor()
    window.el = @$el


  _initStepManager: =>
    stepsConfig =
      element: @$el[0]
      stepsOrdering: ['info', 'description', 'team']
    @stepManager = new StepManager(stepsConfig)
    window.sm = @stepManager

  _initTeamEditor: =>
    teamConfig =
      element: $(@config.teamElementSelector, @$el)[0]
      communityId: @$communityInput.val()
    @teamEditor = new TeamEditor(teamConfig)
    window.te = @teamEditor

  bindings: =>
    @$communityInput.bind 'change', @onCommunityChange
    @$el.bind('keydown', @config.focusableInputsSelector, @preventEnterSubmit)

  preventEnterSubmit: (e)=>
    key = (if e.charCode then e.charCode else (if e.keyCode then e.keyCode else 0))
    return true unless key is 13
    e.preventDefault()

  onCommunityChange: (ev)=>
    @teamEditor.setCommunityId(@$communityInput.val())

  _setUi: =>
    @$communityInput = $(@config.communityInputSelector, @$el)
    @$calendarIcons = $(@config.datepickerIconSelector, @$el)
    new InputsManager(inputsManager) for inputsManager in $(@config.inputsManager, @$el)

app.initializer.addComponent 'ProjectsForm'