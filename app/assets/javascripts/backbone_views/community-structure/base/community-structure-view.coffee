Departments = require "collections/departments"
DepartmentJobs = require "collections/department-jobs"
MembershipsContracts = require "collections/memberships-contracts"
changesObserver = require "collections/changes-observer"

CommunityStructurePanelView = require "backbone_views/community-structure/base/community-structure-panel-view"
DroppableView = require "backbone_views/base/droppable-view"


class CommunityStructureView extends DroppableView
  template: "community-structure"
  autoRender: true

  initialize: =>
    super
    @bindings()

    # try to use community-fix.css
#    $(@$el).css 'height', $(document).height() - 300
#    $(window).resize =>
#      $(@$el).css 'height', $(document).height() - 300

    @departmentsTumblers = {}

    PersonalTreeView = require "backbone_views/community-structure/personal-tree/personal-tree-view"
    @personalTreeView = new PersonalTreeView

  hideStructurePanel: =>
    @structurePanel.hide()

  showStructurePanel: =>
    @structurePanel.show()

  bindings: =>
    @disableModes()
    $(window).on "new-tab:community-participants", @disableModes
    $(window).on "new-tab:community-departments", @disableModesAndShowPanel
    $(window).on "new-tab:members-details", @hideStructurePanel

  fetchAndDrawCollections: =>
    window.jobs = new DepartmentJobs(
      [], communityId: window.gon.communityId
    )
    window.jobs.fetch
      data:
        per: 5000
      processData: true

    window.jobs.bind "personal-tree", @showPersonalTree


    window.workers = new MembershipsContracts(
     [], communityId: window.gon.communityId
    )
    window.workers.communityId =  window.gon.communityId
    window.workers.fetch
      data:
        per: 5000
      processData: true
      success: =>
        @drawPanel()


    window.departments = @departments = new Departments(
      [], communityId: window.gon.communityId
    )
    @departments.fetch
      data:
        per: 5000
      success: =>
        @drawDepartments()


  render: =>
    super
    ChangeJobView = require "backbone_views/community-structure/departments-tree/change-job-view"
    window.changeJobView = @changeJobView = new ChangeJobView()
    @bindings()
    @fetchAndDrawCollections()
    @$el.addClass 'is-loading'

    $(window).bind "cs:state", (ev, state)=>
      @setState state
    @setState()

    @

  drawPanel: =>
    @structurePanel = new CommunityStructurePanelView collection: window.workers
    @panelContainer = $ '.community-structure-panel-view'
    @panelContainer.empty()
    el = @structurePanel.render().el
    @panelContainer.append el
    app.initializer.initialize(el)
#    @trigger 'workers:loaded'
#    window.workers.each (worker)=>
#      worker.trigger 'change:boss'
    @departmentsView.refresh() if @departmentsView

  drawDepartments: =>
    DepartmentView = require "backbone_views/community-structure/departments-tree/department-view"
    # Draw root drop area
    # Draw from root departments
    #TODO stops here, we got too many refreshing on canceling changes
    @children = []
    @$el.empty()
    @$el.append '<ol class="departments"></ol>'
    departmentsEl = @$ 'ol.departments'
    departmentsEl.append '<div class="root-line"></div>'
    departmentsEl.append '<div class="root-line-clear"></div>'
    @root = @departments.root()
    @departmentsView = new DepartmentView(
      model: @root,
      parent: @,
      collection: @root.children()
    )

    @personalTreeView.render().$el.appendTo @el

    @departmentsView.render().$el.appendTo departmentsEl
    @changeJobView.render().$el.addClass("structure-popup").prependTo @el
    @domBindings()
    @$el.removeClass 'is-loading'

  showPersonalTree: (worker)=>
    @personalTreeView.show worker
    @$el.scrollTop 0

  setState: (state="base") =>
    states = ["personal-tree", "base"]
    if state in states
      @$el.removeClass states.join(" ")
      @$el.addClass state

  refresh: =>
    @$el.empty()
    @drawPanel()
    @drawDepartments()
    changesObserver.reset()

  disableModesAndShowPanel: =>
    @showStructurePanel()
    @disableModes()

  disableModes: =>
    window.displayMode.disableMode("filters", true)
    window.displayMode.disableMode("list", true)

app.initializer.addComponent CommunityStructureView,
  view: true
  className: 'community-structure-view',
  handler: (obj)->
    window.structureView = obj
