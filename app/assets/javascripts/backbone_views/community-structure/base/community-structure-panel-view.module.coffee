Department = require "models/department"
DepartmentJob = require "models/department-job"
changesObserver = require "collections/changes-observer"
View = require "backbone_views/base/view"


class CommunityStructurePanelView extends View
  template: "community-structure-panel"
  className: "community-structure-panel"

  autoRender: false

  bindings: =>
    window.workers.bind 'change', @populateDepartmentsSelect
    window.departments.bind 'change', @populateDepartmentsSelect

  structureView: =>
    window.structureView

  populateWorkersSelect: =>
    workers = @collection.unallocated()
    if @workersSelect
      @workersSelect.empty()
      @workersSelect.append $("<option value></option>")
      workers.each (worker)=>
        @workersSelect.append $("<option></option>").val(worker.get("id")).html(worker.get("name"))
      @workersSelect.select2()

  populateDepartmentsSelect: =>
    if @departmentsSelect
      @departmentsSelect.empty()
      @departmentsSelect.append $("<option value></option>")
      window.departments.each (department)=>
        if department.visible()
          if department.get('is_root')
            selected =  "selected=true"
          else
            selected = ""
          @departmentsSelect.append $("<option #{selected}></option>").val(department.get("id")).html(department.get("title"))
      @departmentsSelect.select2()

  refreshNewDepartmentPopup: =>
    @departmentErrors.hide()
    @populateWorkersSelect()
    @populateDepartmentsSelect()

  draw: =>
    @departmentForm = $ '.new-department form', @el
    @departmentForm.submit @saveDepartment
    @cancelLink = $ 'a.delete', @departmentForm
    @cancelLink.click =>
      $('body').trigger('click')
    @communityView = $ '.community-view-column'
    @departmentErrors = $ '.errors.department', @departmentForm
    @contractErrors = $ '.errors.contract', @departmentForm
    @departmentsSelect = $ 'select#department_parent_id', @el
    @newDepartmentPopup = @$ 'div.adding-form.new-department'
    @newDepartmentPopup.bind 'popup:shown', @refreshNewDepartmentPopup
    @workersSelect = $ 'select#department_boss_id', @el

    UnallocatedWorkersView = require "backbone_views/community-structure/base/unallocated-workers-view"
    @unallocatedWorkersView = new UnallocatedWorkersView
      collection: @collection,
      el: $('.unallocated-btn', @$el)
    @unallocatedWorkersView.render()

  render: =>
    super
    @bindings()
    @draw()
    $(window).bind "cs:state", (ev, state)=>
      @setState state
    @setState()

    @

  refresh: =>
    super
    @unallocatedWorkersView.unbind()
    @draw()
    @

  refreshWorkers: =>
    @unallocatedWorkersView.collection = @collection.unallocated()
    @unallocatedWorkersView.refresh()

  saveDepartment: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @newDepartmentPopup.addClass 'is-loading'
    newDepartment = new Department
      title: @departmentForm.find('input#department_title').val()
      parent_id: @departmentsSelect.val()
      community_id: window.gon.communityId
    ,
      skipWatching: true

    newDepartment.save null,
      success: (model, response)=>
        newDepartment.deleteOnRestore = true
        changesObserver.add newDepartment
        window.departments.add newDepartment
        for jobKey in ['boss_job', 'default_job']
          newJob = new DepartmentJob response[jobKey]
          window.jobs.add newJob
        parent = newDepartment.parent()
        parent.trigger 'change' if parent
        @newDepartmentPopup.removeClass 'is-loading'
        $('body').trigger('click')
        if @workersSelect.val() && response['boss_job_id']
          worker = window.workers.findWhere({id: parseInt(@workersSelect.val())})
          if worker
            worker.set 'department_job_id', response['boss_job_id']
#              success: (model, response)=>
#                @structureView().refresh()
#              error: (model, response)=>
#                @drawErrors response, @contractErrors, 'Отдел сохранен, но не удалось назначить руководителя отдела!'
      error: (model, response)=>
        @newDepartmentPopup.removeClass 'is-loading'
        @drawErrors response, @departmentErrors

  drawErrors: (response, container, customMsg='')=>
    window.errorHandler response, false, (msg)->
      container.empty()
      if customMsg
        container.append $("<span></span>").html(customMsg)
      for line in msg.split("\n")
        container.append $("<li></li>").html(line)
      container.show()

  hide: =>
    $(@el).hide()

  show: =>
    $(@el).show()

  setState: (state="base") =>
    states = ["personal-tree", "base"]
    if state in states
      @$el.removeClass states.join(" ")
      @$el.addClass state

module.exports = CommunityStructurePanelView
