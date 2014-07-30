class window.TaskForm
  constructor: (el) ->
    @el = $ el
    @defaultExecutor = @el.data 'default-executor'
    @defaultCommunity = @el.data('default-community').toString()
    @form = $ 'form', @el
    @executorInput = $ '#base_task_executor_id', @form
    @kindInput = $ '.task-kind-input', @el
    @submitBtn = $ '[role="input-submit"]', @form
    @toAllCommunity = $ '#base_task_to_all_community'
    @taskExecutorContainer = $ '[role="task-executor"]', @form
    @saveAsTemplateLink= $ '[role="save-as-template"]', @el
    @saveAsTemplateLink.click @saveAsTemplate
    @toAllCommunity.change @toAllCommunityChecked
    @selectTemplateLink = $ '[role="select-template"]', @el
    @communitySelect = $ '[role="community"] select', @form
    @communitySelect.change @showExecutors
    @taskExecutorContainer.hide() unless  @taskExecutorContainer.hasClass('show')
    @titleInput =  $ 'input#base_task_title', @form
    setTimeout =>
      @titleInput.focus()
    , 0
#    @form.bind 'keypress', 'input', @preventEnterSubmit
    val = @communitySelect.val()
    if val == @defaultCommunity || val == ''
      @toAllCommunity.parent().hide()

    descriptinText = $ 'textarea', @form
    IQ300.Plugin.use 'jquery-autosize', ->
      descriptinText.autosize()


  preventEnterSubmit: (e) =>
    if e.which is 13
      $targ = $ e.currentTarget
      if not $targ.is("textarea") and not $targ.is(":button,:submit")
        false

  showExecutors: =>
    val = @communitySelect.val()
    if val == @defaultCommunity || val == ''
      @taskExecutorContainer.hide()
      @toAllCommunity.parent().hide()
    else
      @taskExecutorContainer.show()
      @toAllCommunity.parent().show()

  saveAsTemplate: (e) =>
    @kindInput.val 'TemplateTask'
    @form.submit()

  toAllCommunityChecked: (e) =>
    target = $ e.target
    if (target.is(':checked'))
      @taskExecutorContainer.hide()
      @taskExecutorContainer.find('select').attr("disabled", "disabled")
    else
      @taskExecutorContainer.show()
      @taskExecutorContainer.find('select').removeAttr("disabled")

app.initializer.addComponent "TaskForm",
  role: "task-form"
