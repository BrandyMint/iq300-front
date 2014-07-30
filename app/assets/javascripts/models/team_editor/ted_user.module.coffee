class TEdUser extends Backbone.Model

  isInTeam: =>
    @get('in_team')

  setAsTeamMember: (group = 'owners')=>
    @set('in_team', true)
    @set('group_name', group)

  setAsNotInTeam: =>
    @set('in_team', false)

  inTeam: (state)=>
    if state then @setAsTeamMember() else @setAsNotInTeam()

  isRestricted: =>
    @get('group_name') != 'owners'

  index: =>
    if @collection
      @collection.indexOf(@)
    else
      -1

  isMembershipPersisted: =>
    !!@get('membership_id')

  remove: =>
    @set('in_team', false)
    if @get('membership_id')
      @set('deleted', true)

  restore: =>
    @set('deleted', false)

  toDelete: =>
    !!@get('deleted')

  searchString: =>
    @get('short_name')

module.exports = TEdUser