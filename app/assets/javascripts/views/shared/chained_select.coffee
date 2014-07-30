class window.ChainedSelect
  constructor: (el)->
    @el = $ el
    @parentSelector = @el.data "parent-selector"
    @parent = if @parentSelector
      @el.parents(@parentSelector).first()
    else
      $ "body"
    @dataChainedSelect = @el.data "chained-select"
    @regExp = /__(.*?)__/g
    @selectedValue = @el.val() || @el.data "selected"
    @targetNames = @dataChainedSelect.match @regExp
    @targets = []
    @nullValue = @el.data "null-value"
    @defaultValue = @el.data "cs-default-value"

    for name_with_trash in @targetNames
      name = unescape name_with_trash.match(/__(.*)__/)[1]
      target = $ "[name='" + name + "']", @parent
      if target.length > 0
        @targets.push target
        target.bind "change", @getOptions
        target.bind "select2-clearing", @getOptions

    if !@el.data "skip-init-req" || (_(@targets).filter (target)->
      !!target.val().length > 0)
      @getOptions()

  getOptions: ()=>
    if @targets.length > 0
      url = @dataChainedSelect
      for name_with_trash, index in @targetNames
        target = @targets[index]
        val = target.val() || ""
        val = @nullValue if val == "" && @nullValue
        @el.data 'selected-value', val
        ignoredVal = target.data("ignore-value") || -1
        if !!val && val != ignoredVal.toString()
          url = url.replace name_with_trash, val
          $.ajax
            url: url
            context: this
            dataType: "json"
            beforeSend: @lockSelect
            success: @updateSelect
            complete: @unlockSelect
        else
          this.clear()
    else
      this.clear()

  clear: ()=>
    @el.empty()
    @el[0].options[0] = new Option()  if @el[0].options
    @el.trigger "change"

  updateSelect: (data)=>
    @el.empty()
    if data[0] && data[0].workers
      for item in data
        optgroup = $("<optgroup>").attr("label", item.text)
        for worker in item.workers
          title = if worker.post == "" || worker.post == "-"
                    worker.full_name
                  else
                    "#{worker.full_name} - #{worker.post}"
          option = $("<option>").attr("value", worker.id).html title
          if worker.id is @selectedValue
            option.prop "selected", "selected"
            @selectedValue = null
          option.appendTo optgroup
        optgroup.appendTo @el
    else
      data = _.union {}, data
      for item in data
        option = $("<option>").attr("value", item.key).html item.name
        if item.key == @selectedValue
          option.prop "selected", "selected"
          @selectedValue = null
        option.appendTo @el
    @setDefaultValue()
    @el.trigger "change"

  setDefaultValue: =>
    $("option[value=#{@defaultValue}]").prop("selected", "selected") if @defaultValue


  lockSelect: =>
#    @el.prop "disabled", "disabled"
    @el.trigger "change"

  unlockSelect: =>
    @el.removeAttr "disabled"
    @el.trigger "change"

app.initializer.addComponent "ChainedSelect"
