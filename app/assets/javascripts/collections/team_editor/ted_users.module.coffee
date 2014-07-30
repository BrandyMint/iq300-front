TEdUser = require "models/team_editor/ted_user"

class TEdUsers extends Backbone.Collection
  model: TEdUser

  comparator:  (m)->
    m.get 'short_name'

  visibleMembers: =>
    new TEdUsers(@_visibleMembersArr())

  isInclude: (model)=>
    !!@visibleMembers().findWhere({id: model.id})

  visibleMembersCount: =>
    @_visibleMembersArr().length

  _visibleMembersArr: =>
    @where({deleted: undefined})

  removeUser: (user)=>
    user.setAsNotInTeam()
    user.remove()
    if user.toDelete()
      @trigger('remove')
    else
      @remove(user)

  addUser: (user, group = 'others')=>
    user.setAsTeamMember(group)
    user.collection = @
    if @isInclude(user)
      member = @findWhere({id: user.id})
      member.restore() if member.toDelete()
      @trigger('add')
    else
      @add(user)

  removeAll: =>
    @visibleMembers().each (user)=>
      @removeUser(user)

module.exports = TEdUsers