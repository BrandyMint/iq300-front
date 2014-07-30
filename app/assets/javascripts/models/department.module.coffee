Model = require "models/base/model"
DepartmentJobs = require "collections/department-jobs"
MembershipsContracts = require "collections/memberships-contracts"

class Department extends Model
  url: =>
    res = "/communities/#{@communityId}/departments"
    res += "/#{@id}" if @id
    res

  validate: (attrs, options)=>
    unless attrs.title == @attributes.title
      @_validateTitle(attrs.title)

  _validateTitle: (title)=>
    if _.trim(title).length < 2
      'activerecord.errors.models.department.title_is_too_small'
    else if _.indexOf(@collection.pluck('title'), title) >= 0
      'activerecord.errors.models.department.title_is_taken'

  children: =>
    Departments = require "collections/departments"
    res = new Departments(window.departments.filter (model)=>
      model.get("parent_id") is @id
    , {communityId: @communityId})

    @attributes.children_ids = res.pluck "id"
    res

  parent: =>
    window.departments.findWhere({id: @get "parent_id"}) if @get "parent_id"

  crew: =>
    job_ids = @jobs().map (job)=>
      job.id
    new MembershipsContracts(window.workers.filter (model)=>
      _.contains job_ids, model.get("department_job_id")
    , {communityId: @communityId})

  jobs: =>
    new DepartmentJobs(window.jobs.filter (model)=>
      model.get("department_id") is @id
    , {communityId: @communityId})

  defaultJob: =>
    window.jobs.findWhere({id: @get('default_job_id')})

  bossJob: =>
    @jobs().findWhere({is_boss: true})

  initialize: ()=>
    super
    @communityId = @get('community_id')
    @
    @bind "change:restore", @touchParent

  touchParent: =>
    parent = @parent()
    parent.trigger "change" if parent

  setBossJob: (newBossJob)=>
    if newBossJob
      oldBossJob = @bossJob()
      newBossJob.set 'is_boss', true
      if oldBossJob
        oldBossJob.set 'is_boss', false
        for worker in @crew().where({department_job_id: oldBossJob.id})
          worker.setJob @defaultJob()
      unless @jobs().findWhere({ id: newBossJob.id})
        window.jobs.add newBossJob

  setParent: (newParent)=>
    if newParent
      @set "parent_id", newParent.id
    else
      @set "parent_id", null

  hasChildren: =>
    @children().size() > 0

  childrenCount: =>
    @children().where({hidden:false}).length

  delayedDestroy: =>
    @removeWorkers @
    super
    parent = @parent()
    parent.trigger "removed:children" if parent

  removeWorkers: (department)=>
    department.crew().each (worker)=>
      worker.setJob null
    department.children().each (child)=>
      @removeWorkers(child)

  isRoot: ()=>
    @get 'is_root'

  searchString: =>
    @get "title"

  destroyDependencies: =>
    @jobs().models

module.exports = Department