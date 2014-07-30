Department = require "models/department"
Collection = require "collections/base/collection"

class Departments extends Collection
  model: Department
  url: =>
    "/communities/#{@communityId}/departments"

  comparator: (m)->
    m.get 'title'

  root: =>
    @findWhere {is_root: true}

  initialize: (models, opts = {})->
    @communityId = opts.communityId

module.exports = Departments