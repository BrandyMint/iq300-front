MembershipsContracts = require "collections/memberships-contracts"
View = require "backbone_views/base/view"

class TaskRulesColumnView extends View
  template: "personal-tree/task-rules-column"
  autoRender: true

  render: =>
    super
    @listenTo @collection, "task-rule-#{@options.taskRule}:change", @toggleTaskRule
    @searchCollection = new MembershipsContracts
    @listenTo @searchCollection, "task-rule-#{@options.taskRule}:change", @toggleRuleBySearch
    @

  domBindings: =>
    SearchView = require "backbone_views/community-structure/personal-tree/search-view"
    @taskRulesContainer = @$ ".task-rules-list"
    unless @search
      @search = new SearchView
        el: @$ ".search"
      @search.bind "searching", @renderSearchResults

    @search.render()
    @searchResultsContainer = @$ ".search-results"
    @drawWorkers()
    app.initializer.initializeOnly "SearchExpander", @el

  refresh: =>
    @drawWorkers()
    @drawSearchResult()

  drawWorkers: =>
    @taskRulesContainer.empty()
    for view in @getWorkersViews(@collection)
      view.$el.appendTo @taskRulesContainer

  drawSearchResult: =>
    @searchResultsContainer.empty()
    @searchResultsContainer.hide()
    if @searchCollection.isEmpty()
      @searchResultsContainer.html("<div class='empty'>" + app.i18n.t('views.community_structure.personal_tree.task_rules.not_found') + "</div>")
    else
      @searchResultsContainer.append("<span>" + app.i18n.t('views.community_structure.personal_tree.task_rules.found') + ":</span>")
    for view in @getWorkersViews(@searchCollection)
      @searchResultsContainer.append view.el
    @searchResultsContainer.slideDown('fast')

  getWorkersViews: (collection)=>
    GroupedWorkersView = require "backbone_views/community-structure/personal-tree/grouped-workers"
    views = []
    collection.groupByDepartment().map (item)=>
      view = new GroupedWorkersView
        model: item.department
        target: @model
        collection: new MembershipsContracts(item.workers)
        taskRuleType: @options.taskRule
      views.push view.render()
    views

  unbind: =>
    super
    @search.unbind "searching", @renderSearchResults if @search

  toggleTaskRule: (worker)=>
    @model.toggleTaskRule worker, @options.taskRule

  toggleRuleBySearch:  (worker)=>
    @toggleTaskRule worker
    if @collection.get(worker.id)
      @collection.remove worker
    else
      @searchCollection.remove worker
      @collection.add worker
      @refresh()

  renderSearchResults: (results)=>
    @searchCollection.reset()
    for result in results
      unless result in @collection.models  || result.job() == undefined
        @searchCollection.push result unless result.id == @model.id

    @refresh()



module.exports = TaskRulesColumnView