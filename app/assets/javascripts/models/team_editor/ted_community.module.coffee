TEdDepartment = require "models/team_editor/ted_department"
TEdDepartments = require "collections/team_editor/ted_departments"
TEdUsers = require "collections/team_editor/ted_users"

class TEdCommunity extends Backbone.Model
  url: =>
    "/api/web/communities/#{@id}/structure"

  init: =>
    @_selectedDepartment = null
    rootDepData = _.extend(@get("departments").root[0], { root: true })
    @rootDepartment = new TEdDepartment(rootDepData)
    @departments = @rootDepartment.children()
    @_initUsers()

  selectedDepartment: =>
    @_selectedDepartment

  selectDepartment: (department)=>
    if @_selectedDepartment == department || !department
      @_selectedDepartment = undefined
    else
      @_selectedDepartment = department
    @trigger 'departments:selected', department

  prettyTitle: =>
    "#{t('common.community')} \"#{@get('title')}\""

  _initUsers: =>
    unallocatedUsers = @get("departments").unallocated
    dataForUnallocated =
      id: -1
      title: t('templates.community_structure.unallocated'),
      members_count: unallocatedUsers.length,
      users: unallocatedUsers
      children: []
    @unallocatedDepartment = new TEdDepartment(dataForUnallocated)
    @users = new TEdUsers(unallocatedUsers)
    @users.add(@rootDepartment.allUsers().models)

module.exports = TEdCommunity