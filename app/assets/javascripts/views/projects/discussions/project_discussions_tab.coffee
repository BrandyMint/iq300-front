ProjectDiscussionsForm = require 'views/projects/discussions/project_discussions_form'
ProjectDiscussionsList = require 'views/projects/discussions/project_discussions_list'

class window.ProjectDiscussionsTab
  constructor: (el)->
    @el = $(el)
    @list = new ProjectDiscussionsList $('.project-discussions', @el)
    @form = new ProjectDiscussionsForm $('.project-discussions-form', @el)

    @bindings()
    @list.refresh()

  bindings: =>
    @form.bind 'discussion:created', @list.addDiscussion

app.initializer.addComponent 'ProjectDiscussionsTab', 'project-discussions-tab'