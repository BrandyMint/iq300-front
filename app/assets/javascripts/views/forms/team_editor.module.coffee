TEdCommunity = require 'models/team_editor/ted_community'
TEdDepartmentView = require 'backbone_views/team_editor/ted_department_view'
TEdUserView = require 'backbone_views/team_editor/ted_user_view'
TEdUsers = require 'collections/team_editor/ted_users'
TEdMemberView = require 'backbone_views/team_editor/ted_member_view'
TEdLocalSearcher = require 'models/team_editor/ted_local_searcher'
TEdGlobalSearcher = require 'models/team_editor/ted_global_searcher'

class TeamEditor
  config:
    header:
      elSelector: '[role=main-header]'
      addAllSelector: '[role=add-all-community]'
      addDepartment: '[role=add-selected-department]'
      template: 'templates/team_editor/ted_header'
      clearBtnSelector: '[role=clear-btn]'
    departments:
      elSelector: '[role=departments-list]'
    users:
      elSelector: '[role=users-list]'
    team:
      elSelector: '[role=team-list]'
      clearBtnSelector: '[role=clear-team]'
      memberSelector: '[role=membership]'
      counterElSelector: '[role=team-counter]'
      memberData:
        id: 'member-id'
        group_name: 'member-group'
        short_name: 'member-short-name'
        membership_id: 'member-membership-id'
    search:
      searchUrl: '/api/web/users'
      elSelector: '[role=search]'
      contextDataAttr: 'context'
      clearBtnSelector: '[role=clear-selected]'

  constructor: (config)->
    @$el = $ config.element
    @community = new TEdCommunity()
    @domBindings()
    @setCommunityId(config.communityId)
    @initTeamCollection()
    @bindings()

  domBindings: =>
    @$headerEl = $(@config.header.elSelector, @$el)
    @$departmentsListEl = $(@config.departments.elSelector, @$el)
    @$usersListEl = $(@config.users.elSelector, @$el)
    @$teamListEl = $(@config.team.elSelector, @$el)
    @$teamCounterEl = $(@config.team.counterElSelector, @$el)
    @$searchInputs = $(@config.search.elSelector, @$el)
    @$searchInputs.bind('keyup', @search)
    @$clearTeamBtn = $(@config.team.clearBtnSelector, @$el)
    @$clearTeamBtn.click @removeAllMembers
    @$clearBtns = $(@config.search.clearBtnSelector, @$el)
    @$clearBtns.click (ev)=>
      @_clearSearchInputs()

  search: (ev)=>
    @$usersListEl.addClass('is-loading')
    $input = $(ev.currentTarget)
    searchContext = $input.data(@config.search.contextDataAttr)
    @_clearSearchInputs(searchContext)
    query = $input.val()
    @_searcher(searchContext).search(query, @setUsers)
    true

  _clearSearchInputs: (exclude = '')=>
    @community.selectDepartment(null)
    @$searchInputs.filter(":not([data-#{@config.search.contextDataAttr}=#{exclude}])").val('')

  _searcher: (context)=>
    if context == 'local'
      @usersContext = 'owners'
      @localSearcher
    else
      @usersContext = 'others'
      @globalSearcher

  bindings: =>
    @community.bind('departments:selected', @onDepartmentSelect)
    @team.bind 'add remove', @renderTeam
    @team.bind 'remove', @renderSelectableUsers

  renderHeader: =>
    @$headerEl.empty()
    @$headerEl.html(JST[@config.header.template]({model: @community}))
    $addAllBtn = $(@config.header.addAllSelector, @$headerEl)
    $addAllBtn.click @addAllCommunity
    $addDepartmentBtn = $(@config.header.addDepartment, @$headerEl)
    $addDepartmentBtn.click @addSelectedDepartment
    $(@config.header.clearBtnSelector, @$el).click (ev)=>
      @_clearSearchInputs()

  renderDepartments: =>
    @$departmentsListEl.empty()
    @renderDepartment(@community.unallocatedDepartment)
    @renderDepartment(@community.rootDepartment)
    @community.departments.each (department)=>
      @renderDepartment(department, true)

  renderDepartment: (department, withSublist = false)=>
    return false if department.users().length == 0 && department.children().length == 0
    opts =
      model: department
      community: @community
      renderSublist: withSublist
    view = new TEdDepartmentView(opts)
    @$departmentsListEl.append(view.render().$el)

  renderSelectableUsers: =>
    @$usersListEl.removeClass('is-loading')
    @$usersListEl.empty()
    return false if !@users || @users.length == 0
    @users.each (user)=>
      user.inTeam(@team.isInclude(user))
      @renderUser(user, @usersContext)

  renderUser: (user, group = 'others')=>
    opts =
      model: user
      community: @community
      team: @team
      group: group
    view = new TEdUserView(opts)
    @$usersListEl.append(view.render().$el)

  initTeamCollection: =>
    $memberEls = $(@config.team.memberSelector, @$teamListEl)
    data = $.map $memberEls, (el)=>
      @parseMembershipData($(el))
    @team = new TEdUsers(data)
    @renderTeam()

  initSearchers: =>
    @localSearcher = new TEdLocalSearcher(@community.users.models)
    @globalSearcher = new TEdGlobalSearcher(@config.search.searchUrl)

  renderTeamCounter: =>
    count = @team.visibleMembersCount()
    text = if count == 0  then '' else count
    @$teamCounterEl.text(text)

  renderTeam: =>
    @renderTeamCounter()
    @$teamListEl.empty()
    @team.each (member)=>
      @renderMember(member)

  renderMember: (member)=>
    opts =
      model: member
      hidden: member.toDelete()
      team: @team
    view = new TEdMemberView(opts)
    @$teamListEl.append(view.render().$el)

  parseMembershipData: ($element)=>
    parsedData = {}
    for attr, selector of @config.team.memberData
      parsedData[attr] = $element.data(selector)
    parsedData

  render: =>
    @community.init()
    @initSearchers()
    @renderHeader()
    @renderDepartments()
    @renderSelectableUsers()
    @renderTeam()

  setCommunityId: (id)=>
    return false unless id
    @community.set('id', id)
    @team.reset() if @team
    @users.reset() if @users
    @community.fetch
      success: @render
      error: window.errorHandler

  onDepartmentSelect: =>
    @usersContext = 'owners'
    @renderHeader()
    users = if @community.selectedDepartment() then @community.selectedDepartment().users() else []
    @setUsers(users)

  setUsers: (users)=>
    @users ||= new TEdUsers
    @users.reset()
    models = if users.models then users.models else users
    @users.set(models)
    @renderSelectableUsers()

  addAllCommunity: =>
    @addToTeam(@community.users, 'owners')

  addSelectedDepartment: =>
    @addToTeam(@community.selectedDepartment().users(), 'owners')

  addToTeam: (users, group)=>
    users.each (user)=>
      @team.addUser(user, group)
    @renderSelectableUsers()

  removeAllMembers: =>
    @team.removeAll()

module.exports = TeamEditor