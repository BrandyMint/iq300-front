TEdUsers = require "collections/team_editor/ted_users"

class TEdDepartment extends Backbone.Model

  initialize: (options)=>
    @root = options.root
    @users()
    @children()
    @allUsers()

  users: =>
    @_users ||= new TEdUsers(@get('users'))

  children: =>
    TEdDepartments = require('collections/team_editor/ted_departments')
    @_children ||= new TEdDepartments(@get('children'))

  allUsers: =>
    unless @_allUsers
      @_allUsers = new TEdUsers()
      @_fetchAllUsers(@_allUsers, @)
    @_allUsers

  _fetchAllUsers: (users, department)=>
    users.add(department.users().models)
    department.children().each (dep)=>
      @_fetchAllUsers(users, dep)

module.exports = TEdDepartment