WidgetList = require 'views/base/widget_list'
ProjectMembersForm = require 'views/projects/members/project_members_form'

class window.ProjectMembersView extends WidgetList
  init: =>
    @form = new ProjectMembersForm($('.project-members-form', @el))
    @form.el.addClass('project-members-form-initialized')
    @form.parent = @

  bindings: =>
    super
    @removeLinks = $('a.remove', @el)
    @conversationLinks = $('.conversation', @el)
    @unbinding()
    @removeLinks.bind('click', @removeUser)
    @conversationLinks.bind('click', @writeMessage)
    @form.resultElement = @infiniteList

  unbinding: =>
    @removeLinks.unbind('click')
    @conversationLinks.unbind('click')

  removeUser: (e)=>
    target = $(e.currentTarget)
    url = target.attr('href')
    confirm = window.confirm(target.data('confirmation'))
    if confirm
      $.ajax
        type: 'delete',
        url: url,
        success: =>
          target.parent('.user-wrapper').remove()
        error: window.errorHandler
    e.preventDefault()

app.initializer.addComponent(ProjectMembersView, 'project-members-view')
