class ChangesObserver
  constructor: ->
    @models = []
    @modelIndexes = {}
    _.extend(@, Backbone.Events)

  mount: (klass)->
    self = @
    old =
      initialize: klass.prototype.initialize
      save: klass.prototype.save
      destroy: klass.prototype.destroy

    klass.prototype.initialize = ->
      old.initialize.apply @, arguments
      self.add @ unless @skipWatching

    klass.prototype.save = ->
      if @get "hidden"
        @destroy arguments[1]
      else
        old.save.apply @, arguments

    klass.prototype.backup = ->
      @backupAttributes = _.clone @attributes
      @changed = {}

    klass.prototype.restore = ->
      if JSON.stringify(@attributes) isnt JSON.stringify(@backupAttributes)
        if @deleteOnRestore
          self._destroyAndRemove @
        else
          @attributes = _.clone @backupAttributes
          @changed = {}
          @trigger "change"
          @trigger "change:restore"

  saveChanges: =>

    gotError = (response)=>
      @clearInterval()
      @trigger 'error:observer'
      @repeatInterval = setInterval =>
         @saveChanges()
      , (@repeatIntervalSize || 5000)

    modelSaveCallback = (model)=>
      @unsavedCount -= 1
      if model
        model.backup()
        model.deleteOnRestore  = false
      if @unsavedCount is 0
        @trigger 'saved'
        @clearInterval()

    @trigger 'saving'
    changedModels = @changedModels()
    @unsavedCount = changedModels.length
    for model in changedModels
      model.save null,
        validate: false
        success: (response)=>
          modelSaveCallback(model)
        error: (model, xhr, options)=>
          gotError(xhr)

  clearInterval: =>
    if @repeatInterval
      clearInterval @repeatInterval
      @repeatInterval = null

  clearCache: =>
    while @pop()
      yes

  changedModels: =>
    res = []
    @_removeDependents()
    for  model in @models
      res.push model if model && (model.isNew() || model.changedAttributes())
    res

  _removeDependents: =>
    for model in @models
      if model && model.get("hidden")
        for dependentObj in model.destroyDependencies()
          @remove dependentObj

  cancelChanges: =>
    _.invoke @models, "restore"
    if @repeatInterval
      @clearInterval()
      @trigger "error-canceled"
    else
      @trigger "canceled"

  onModelChange: =>
    @trigger "change"

  onModelChangeHidden: (model)=>
    if model.get("hidden") && model.deleteOnRestore
      @_destroyAndRemove model

  _destroyAndRemove: (model)=>
      for dependentObj in model.destroyDependencies()
        @remove dependentObj
      model.destroy
        success: =>
          @trigger "canceled" unless @hasChanges()

  add: (model)=>
    model.skipWatching = false
    className = model.className()
    @modelIndexes[className] = {} unless @modelIndexes[className]
    model.bind "change", @onModelChange
    model.bind "change:hidden", @onModelChangeHidden
    model.bind "destroy", @remove
    model.backupAttributes = _.clone(model.attributes)
    unless @modelIndexes[className][model.id]
      @models.push model
      @modelIndexes[className][model.id] = @models.length - 1

  _modelIndex: (model)=>
    className = model.className()
    if @modelIndexes[className]
      @modelIndexes[className][model.id]

  remove: (model)=>
    index = @_modelIndex model
    if index
      @models.splice index, 1
      delete @modelIndexes[model.className()][model.id]
      model.unbind "change", @onModelChange
      model.unbind "change:hidden", @onModelChangeHidden
      for m in @models.slice(index, @models.length)
        @modelIndexes[m.className()][m.id] = @modelIndexes[m.className()][m.id] - 1

  hasChanges: =>
    @changedModels().length > 0

MembershipsContract = require "models/memberships-contract"
Department = require "models/department"
DepartmentJob = require "models/department-job"


changesObserver = new ChangesObserver()

changesObserver.mount Department
changesObserver.mount MembershipsContract
changesObserver.mount DepartmentJob

module.exports = changesObserver
