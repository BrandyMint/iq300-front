DepartmentJob = require "models/department-job"
Collection = require "collections/base/collection"

class DepartmentJobs extends Collection
  model: DepartmentJob
  url: =>
    "/communities/#{@communityId}/department_jobs.json"

  comparator: (m)->
    m.get 'title'

  initialize: (models, opts = {})=>
    @communityId = opts.communityId

module.exports = DepartmentJobs