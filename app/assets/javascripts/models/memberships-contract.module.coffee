Model = require "models/base/model"

class MembershipsContract extends Model
  initialize: =>
    super
    @communityId = @get('consumer_community_id')
    @bind "change:restore", @touchDepartment

  job: =>
    window.jobs.findWhere({id: @get('department_job_id')})

  url: =>
    res = "/communities/#{@communityId}/workers"
    res += "/#{@id}" if @id
    res

  touchDepartment: =>
    department = @department()
    department.trigger "change" if department

  department: =>
    job = @job()
    if job
      window.departments.findWhere {id: job.get('department_id')}
    else
      null

  post: =>
    job = @job()
    job.get 'title' if job

  setJob: (newJob)=>
    if newJob == null
      @set 'department_job_id', null
    else
      oldJob = @job()
      @set 'department_job_id', newJob.id
      if newJob.get('is_boss') || (oldJob && oldJob.get('is_boss'))
        @trigger 'change:boss'

  isBoss: =>
    job = @job()
    job && job.get 'is_boss'

  photo: (size = 'thumb')=>
    @get('photo')[size]

  defaultSlaveIds: =>
    department = @department()
    job = @job()
    defaultSlaveIds = []
    if job && department
      if job.get "is_boss"
        defaultSlaveIds = _(department.children().map (dep)=>
          bossJob = dep.bossJob()
          if bossJob
            boss = bossJob.contract()
            boss.id if boss
        ).compact()
      depBossJob = department.bossJob()
      department.crew().each (worker)=>
        if worker.id != @id && (depBossJob == undefined || worker.job().id != depBossJob.id)
            defaultSlaveIds.push worker.id
    defaultSlaveIds

  slaveIds: =>
    bannedSlaveIds =  @get "banned_slave_ids"
    slave_ids =  @get "slave_ids"
    _.union(_.difference(@defaultSlaveIds(),bannedSlaveIds), slave_ids)

  defaultMasterIds: =>
    department = @department()
    defaultMasterIds = []
    job = @job()
    if job && department
      bossJob = department.bossJob()
      if job.get "is_boss"
        parent = department.parent()
        if parent && parent.bossJob()
          defaultMasterIds =  _(parent.bossJob().workers().map (worker)=>
            worker.id
          ).compact()
      else
#        defaultMasterIds = _(bossJob.workers().map (worker)=>
#          worker.id
#        ).compact()
        department.crew().each (worker)=>
          if worker.id != @id #&& worker.job().id != bossJob.id
            defaultMasterIds.push worker.id
    defaultMasterIds

  masterIds: =>
    bannedMasterIds =  @get "banned_master_ids"
    master_ids =  @get "master_ids"

    _.union(_.difference(@defaultMasterIds(),bannedMasterIds), master_ids)

  slaves: =>
    ids = @slaveIds()
    window.workers.filter (model)=>
      _.contains ids, model.id

  masters: =>
    ids = @masterIds()
    window.workers.filter (model)=>
      _.contains ids, model.id

  toggleTaskRule: (worker, rule, changeBoth=true)=>
    return false unless (worker && rule)
    word = _.singularize rule
    toTitleCase = (str)-> str.charAt(0).toUpperCase() + str.substr 1
    titleCaseWord = toTitleCase word
    attrIds = "#{word}_ids"
    bannedAttrIds = "banned_#{attrIds}"
    ids = _.clone  @get attrIds
    bannedIds = _.clone  @get bannedAttrIds
    method = @["#{word}Ids"]
    defaultMethod = @["default#{titleCaseWord}Ids"]
    if _.contains method(), worker.id
      if _.contains defaultMethod(), worker.id
        bannedIds.push worker.id
        @attributes[bannedAttrIds] =  bannedIds
      @attributes[attrIds] = _.without(ids, worker.id)
    else
      ids.push worker.id
      @attributes[attrIds] = ids
      @attributes[bannedAttrIds] = _.without(bannedIds, worker.id)

    @changed["updated_at"] = new Date()
    @trigger "change"

    if changeBoth
      oppositeRule = if rule == "master" then "slave" else "master"
      worker.toggleTaskRule @, oppositeRule, false

  searchString: =>
    job = @job()
    jobStr = job.searchString() if job
    dep = @department()
    depStr = dep.searchString() if dep
    [@get("name"), @get("title"), jobStr, depStr].join " "

module.exports = MembershipsContract
