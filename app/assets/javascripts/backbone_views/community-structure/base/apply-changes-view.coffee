changesObserver = require "collections/changes-observer"
View = require "backbone_views/base/view"

class ApplyChangesView extends View
  template: "apply-changes"
  className: "apply-changes"
  autoRender: yes

  render: =>
    super
    @collection = changesObserver
    @toggle = _.debounce(@toggle, 50)
    @toggle no
    $(window).bind "new-tab", @_hide
    $(window).bind "new-tab:community-participants", =>
      @toggle(window.changesObserver.hasChanges()) if window.changesObserver
    @collection.bind "change", =>
      window.onbeforeunload = @confirmClose
      @toggle yes

    @collection.bind 'saving', =>
      $(@el).addClass('saving')

    @collection.bind 'saved', =>
      $(@el).removeClass('saving')
      $(@el).removeClass('error')
      window.onbeforeunload = undefined

    @collection.bind 'error:observer', =>
      $(@el).addClass('error')
      @$('.error').addClass('is-loading')
      @toggle yes

    acceptBtn = @$ ".accept"
    acceptBtn.click @collection.saveChanges
    declineBtn = @$ ".decline"
    declineBtn.click =>
      @collection.cancelChanges()
      $(@el).removeClass('saving')
      $(@el).removeClass('error')
      @$('.error').removeClass('is-loading')

    @collection.bind "error-canceled saved canceled",  =>
      @toggle no
      window.onbeforeunload = undefined

    @

  confirmClose: (ev)=>
    message = app.i18n.t('views.community_structure.base.apply_changes.not_saved')
    if ev == undefined
      ev = window.event
    if ev
      ev.returnValue = message
    message

  toggle: (changes)=>
    @$el.toggle changes

app.initializer.addComponent ApplyChangesView,
  view: true

