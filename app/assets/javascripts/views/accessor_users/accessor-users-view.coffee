Widget = require 'views/base/widget'

class AccessorUsersView extends Widget

  bindings: =>
    @form = $ ".add-user form", @el
    @removeLinks = $ ".remove", @el
    @removeLinks.click @removeUser
    @conversationLinks = $ ".conversation", @el
    @conversationLinks.click @writeMessage
    @searchInput = $ "input.search", @form
    @existUserIds = @searchInput.data "exists"
    @initilizeSelect2()

  initilizeSelect2: =>
    @url = @searchInput.data 'url'
    @placeholder = @searchInput.data 'placeholder'
    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', =>
        @searchInput.select2
          placeholder: @placeholder
          minimumInputLength: 2
          ajax:
            url: @url
            dataType: 'json'
            data: (term, page) ->
              search: term # search term
              per: 10
              for: 'accessors'
            results: (data, page) =>
              res = []
              for user in data.users
                unless _.contains @existUserIds, user.id
                  res.push user
              results: res
          formatResult: @userFormatResult
          formatSelection: (user) =>
            "<a href=\"/users/#{user.id}\" class=\"link\">#{user.name}</a> <span>(#{user.email})</span>"
          dropdownCssClass: "bigdrop"
          escapeMarkup: (m) ->
            m
        @searchInput.on "change", =>
          @addUser()


  userFormatResult: (data) =>
    User = require "models/user"
    UserView = require "backbone_views/users/user-view"

    user = new User data
    new UserView(model: user).render().el

  userFormatSelection: (user) =>
    user.name

  addUser: =>
    @data = @form.serialize()
    url = @form.attr 'action'
    $.ajax
      type: 'post',
      url: url,
      data: @data
      success: (response) =>
        new window.Flash(@getSuccessMessage(url))
        @draw(response)
      error: window.errorHandler

  removeUser: (ev) =>
    target = $ ev.currentTarget
    url = target.attr 'href'
    confirm = window.confirm target.data('confirmation')
    if confirm
      $.ajax
        type: 'delete',
        url: url,
        success: @draw,
        error: window.errorHandler
    ev.preventDefault()

  getSuccessMessage: (url) =>
    userName = @searchInput.select2('data').name
    if url.search(/tasks/) > 0
      return "#{userName} добавлен наблюдателем этой задачи!"
    if url.search(/attachments/) > 0
      return "#{userName} добавлен читателем этого документа!"

app.initializer.addComponent AccessorUsersView, 'accessor-users-view'
