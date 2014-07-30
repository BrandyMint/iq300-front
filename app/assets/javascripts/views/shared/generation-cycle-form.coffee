class window.GenerationCycleForm
  constructor: (el)->
    @el = el
    @enableCheckbox = $ ".enable-generation-cycle", @el
    @enableCheckbox.change @updateView

    @cycleTypeField = $ "input.cycle-type", @el
    @cycleTypes = $ ".cycle-types li", @el
    @cycleTypes.click @selectCycleType
    @countLabel = $ ".count-label", @el

    @isCycledFields = $ "input.is-cycle", @el
    @nonCycledFields = $ "input.non-cycle", @el

    @businessOnlyLabel = $ "label.business-only", @el

    @setDefaultCycleType()
    @updateView()


  updateView: =>
    checked = @enableCheckbox.is ":checked"
    $(".gc-enabled", @el).toggleClass("hidden", !checked)
    $(".gc-disabled", @el).toggleClass("hidden", checked)


    if checked
      @isCycledFields.removeAttr "disabled"
      @nonCycledFields.attr "disabled", "disabled"
    else
      @nonCycledFields.removeAttr "disabled"
      @isCycledFields.attr "disabled", "disabled"


  selectCycleType: (ev)=>
    target = $ ev.currentTarget
    @cycleTypes.removeClass "selected"
    target.addClass "selected"
    type = target.data "type"
    @cycleTypeField.val type
    @updateLabels()


  setDefaultCycleType: =>
    currentTypeVal = @cycleTypeField.val()
    currentType = if currentTypeVal
      $(".cycle-types li[data-type='#{currentTypeVal}']")
    else
      @cycleTypes.first()
    currentType.addClass "selected"
    @updateLabels()

  updateLabels: =>
    $("span", @countLabel).not(".original").addClass "hidden"
    type = @cycleTypeField.val() || "days"
    $("span.#{type}-enabled", @countLabel).removeClass "hidden"
    @businessOnlyLabel.toggle(type == "days")


app.initializer.addComponent "GenerationCycleForm"