TEdUsers = require 'collections/team_editor/ted_users'

class TEdGlobalSearcher

  constructor: (url)->
    @url = url
    @fetch = _.throttle(@_fetchUsers, 1000)

  search: (query, callback)=>
    if query.trim().length > 1
      @fetch(query, callback)

  _fetchUsers: (query, callback)=>
    $.ajax
      url: @url
      dataType: 'JSON'
      data: { search: query }
      success: (response)=>
        users = @_parse(response.users)
        callback(users)
      error: window.errorHandler

  _parse: (response)=>
    new TEdUsers(response).models

module.exports = TEdGlobalSearcher