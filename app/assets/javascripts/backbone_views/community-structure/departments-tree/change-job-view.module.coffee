DepartmentJob = require "models/department-job"
changesObserver = require "collections/changes-observer"
View = require "backbone_views/base/view"

class ChangeJobView extends View
  template: "change-job"
  className: "edit-job"
  autoRender: no

  render: =>
    super
    @

  domBindings: =>
    @jobsSelect = $ 'input#worker_job_id', @$el
    @closeLink = $ "a.close", @$el
    @closeLink.click @hidePopup
    @scrollContainer().scroll @followOnScroll

    @editJobForm = $ "form", @$el
    @editJobForm.submit @saveJob
    @jobsSelect = $ 'input#worker_job_id', @$el
    @populateSelect({})
    $("body").click (ev)=>
      target = $ ev.target
      if target.hasClass(".structure-popup") || target.parents(".structure-popup").length > 0  || target.closest(".popup-trigger").length > 0
      else
        @hidePopup()

  scrollContainer: =>
    window.structureView.$el

  followOnScroll: =>
    if @$el.hasClass "shown"
      newScrollTop = @scrollContainer().scrollTop()
      if newScrollTop > @currentScrollTop
        delta = (newScrollTop - @currentScrollTop) * -1
      else
        delta = @currentScrollTop - newScrollTop

      oldElTop = parseInt(@$el.css "top")
      @$el.css "top", oldElTop + delta
      @currentScrollTop = newScrollTop

  showPopup: (ev)=>
    @hidePopup()
    ev.stopPropagation()
    ev.preventDefault()
    target = $ ev.currentTarget
    modelId =  target.data 'model-id'
    @model = window.workers.findWhere {id:  parseInt(modelId)}
    @showPopupForModel target

  showPopupForModel: (btnElement)=>
    if @model
      @refreshJobsSelect @model.department()
      $('input#worker_id', @$el).val(@model.id)
      $('input#worker_is_boss', @$el).prop 'checked', @model.isBoss()
      @jobsSelect.select2('val', @model.job().id)
      personalTree = @$ ".personal-tree"
      personalTree.html "Правила постановки задач"
      personalTree.click =>
        @hidePopup()
        @model.job().trigger "personal-tree", @model
    btnElement.parent().addClass 'popup-opened'
    targetPosition = btnElement.offset()
    @$el.css {'position': 'fixed', 'left': targetPosition.left - @$el.width() + 5, 'top': targetPosition.top  + 18}
    @currentScrollTop = @scrollContainer().scrollTop()
    @$el.addClass 'shown'
    @scrollContainer().addClass 'popup-opened'

  refreshJobsSelect: (department)=>
    if department && @jobsSelect
      jobsData = department.jobs().map (job)=>
        {id: job.get('id'), text: job.get('title')}
      @populateSelect jobsData

  populateSelect: (jobsData)=>
    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', =>
        @jobsSelect.select2
          minimumInputLength: 0
          width: '280px'
          data: {results: jobsData, text: 'text'}
          createSearchChoice: (term)=>
            {id: -1, text: term}

  hidePopup: =>
    $('.popup-opened', window.structureView.el).removeClass 'popup-opened'
    @scrollContainer().removeClass 'popup-opened'
    @$el.removeClass "shown"

  saveJob: (ev)=>
    ev.stopPropagation()
    ev.preventDefault()
    if @model
      department = @model.department()
      isBoss = $('input#worker_is_boss', @popup).prop 'checked'
      jobData = $('input#worker_job_id', @popup).select2('data')
      job = @getJobByData jobData.id, jobData.text, isBoss, department
      @setJobForModel job, isBoss

  setJobForModel: (job, isBoss)=>
    if @model && job
      department = job.department()
      defaultJob = department.defaultJob()
      currentJob = @model.job()
      if department
        if isBoss
          if job.id != defaultJob.id
            department.setBossJob job
          else
            job = department.bossJob()
        else
          if job.id == currentJob.id && currentJob.get('is_boss')
            job = defaultJob
        if job.get 'is_boss'
          for boss in  department.crew().where({department_job_id: job.id})
            boss.setJob defaultJob
        @model.setJob job
        @hidePopup()



  getJobByData: (id, title, isBoss, department)=>
    if id == -1
      job =  new DepartmentJob
        title:title
        department_id:department.id
        is_boss:false
      ,
        skipWatching: true
      job.save null,
        success: (model, response)=>
          changesObserver.add model
          window.jobs.add model
          @refreshJobsSelect department
          @jobsSelect.select2 'val', response['id']
          @setJobForModel model, isBoss
        error: (model, response)=>
          @drawErrors response, $('ul.errors', @$el)
          return false
      null
    else
      department.jobs().findWhere({id: id})

  drawErrors: (response, container, customMsg='')=>
    window.errorHandler response, false, (msg)->
      container.empty()
      if customMsg
        container.append $("<span></span>").html(customMsg)
      for line in msg.split("\n")
        container.append $("<li></li>").html(line)
      container.show()


module.exports = ChangeJobView
