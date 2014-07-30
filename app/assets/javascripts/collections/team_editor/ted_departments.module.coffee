TEdDepartment = require "models/team_editor/ted_department"

class TEdDepartments extends Backbone.Collection
  model: TEdDepartment

  comparator:  (m)->
    m.get 'title'

module.exports = TEdDepartments