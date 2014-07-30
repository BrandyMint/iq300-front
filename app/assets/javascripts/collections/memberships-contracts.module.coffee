MembershipsContract = require "models/memberships-contract"
Collection = require "collections/base/collection"

class MembershipsContracts extends Collection
  model: MembershipsContract
  url: =>
    "/communities/#{@communityId}/workers"
  comparator:  (m)->
    m.get 'name'

  unallocated: =>
    new MembershipsContracts(@filter (model)=>
        !model.get("department_job_id")
    , {communityId: @communityId}
    )

  initialize: (models, opts = {})=>
    @communityId = opts.communityId

  groupByDepartment: =>
    departments = []
    res = {}
    @each (worker)=>
      department = worker.department()
      if department
        unless _.contains(departments, department.id)
          departments.push department.id
          res[department.id] = {}
          res[department.id].department = department
          res[department.id].workers = []
        res[department.id].workers.push worker
    out = []
    for key, value of res
      out.push value
    out

module.exports = MembershipsContracts