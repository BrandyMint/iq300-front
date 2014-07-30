StoredCheckbox = require 'views/shared/stored_checkbox'

class window.TaskDiscussionView extends window.DiscussionView
  filters:
    hideActivities: 'task_comments_filter'
  ui:
    filterSelector: ".task-comments-filter input[type='checkbox']"

  init: =>
    @filter = new StoredCheckbox($(@ui.filterSelector, @el.parent()),
      @filters.hideActivities
    )
    @filtered = @filter.isChecked()
    super

  bindings: =>
    super
    @filter.bind('changed', @updateDiscussion)

  updateDiscussion: (checked)=>
    @filtered = checked
    @refreshList()

  refreshList: =>
    setTimeout =>
      @_changeUrl()
      @commentsList.setDefaultPage()
      @commentsList.refresh()
    , 0

  _changeUrl: =>
    @commentsList.params['only_main'] = @filtered or false

app.initializer.addComponent 'TaskDiscussionView', 'task-discussion'