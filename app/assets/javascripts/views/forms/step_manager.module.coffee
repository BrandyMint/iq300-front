Step = require '/views/forms/step'

class StepManager
  config:
    backBtnSelector: '[role=step-back-btn]'
    backBtnTitleSelector: '[role=btn-title]'
    nextBtnSelector: '[role=step-next-btn]'
    stepSwitcherSelector: '[role=step-switcher]'
    stepSelector: '[role=form-step]'
    informerSelector: '[role=step-indicator]'
    activeIndicatorClass: 'active'

  constructor: (options)->
    @$el = $ options.element
    @stepsOrdering = options.stepsOrdering

    @bindings()

    @_initSteps(@stepsOrdering)
    @_initStepsInformer()

  bindings: =>
    @$backBtn = @$el.find(@config.backBtnSelector)
    @$backBtnTitleEl = @$el.find(@config.backBtnTitleSelector)
    @$backBtn.click @stepBack
    @$nextBtn = @$el.find(@config.nextBtnSelector)
    @$nextBtn.click @nextStep
    @$customStepBtn = @$el.find(@config.stepSwitcherSelector)
    @$customStepBtn.click @toCustomStep
    @$informerElements = $(@config.informerSelector, @$el)

  stepBack: (ev)=>
    ev.preventDefault() if ev
    @goToStep(@currentStep.position - 1)

  nextStep: (ev)=>
    ev.preventDefault() if ev
    @goToStep(@currentStep.position + 1)

  toCustomStep: (ev)=>
    ev.preventDefault()
    step = $(ev.currentTarget).data('step')
    @goToStep(step)

  _initSteps: (ordering)=>
    @_steps = {}
    position = 1
    for stepName in ordering
      stepConfig =
        name: stepName
        element: @$el.find("#{@config.stepSelector}[data-step=#{stepName}]")[0]
        position: position++
      step = new Step(stepConfig)
      step.hide() unless step.position == 1
      @_steps[stepName] = step
    @currentStep = @stepByPosition(1)

  _initStepsInformer: =>
    @$informerElements.removeClass(@config.activeIndicatorClass)
    @$informerElements.siblings("[data-step=#{@currentStep.name}]").addClass(@config.activeIndicatorClass)
    prevStep = @getStep(@currentStep.position - 1)
    if prevStep
      @$backBtnTitleEl.text("Назад к п.#{prevStep.position} \"#{prevStep.translatedName()}\"")
      @$backBtn.show()
    else
      @$backBtn.hide()


  stepByPosition: (position)=>
    @_steps[@stepsOrdering[position - 1]]

  stepByName: (name)=>
    @_steps[name]

  stepByInstance: (step)=>
    for name, instance of @_steps
      return instance if step == instance
    undefined

  getStep: (step)=>
    switch typeof(step)
      when 'string' then @stepByName(step)
      when 'number' then @stepByPosition(step)
      when 'object' then @stepByInstance(step)
      else undefined

  goToStep: (step)=>
    nextStep = @getStep(step)
    if nextStep && @currentStep.isValid()
      previousStep = @currentStep
      @currentStep = nextStep
      @_displayCurrentStep(previousStep)
    else
      @displayErrors()

  _displayCurrentStep: (previousStep)=>
    @_initStepsInformer()
    previousStep.hide =>
      @currentStep.show()

  displayErrors: ()=>

module.exports = StepManager
