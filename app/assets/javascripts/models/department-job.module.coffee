Model = require "models/base/model"

class DepartmentJob extends Model
  url: =>
    res = "/communities/#{@communityId || gon.communityId}/department_jobs"
    res += "/#{@id}" if @id
    res

  initialize: =>
    super
    @communityId = @get "community_id"

  department: =>
    window.departments.findWhere
      id: @get "department_id"

  contract: =>
    window.workers.findWhere
      department_job_id: @id

  workers: =>
    window.workers.where
      department_job_id: @id

  searchString: =>
    @get "title"

module.exports = DepartmentJob