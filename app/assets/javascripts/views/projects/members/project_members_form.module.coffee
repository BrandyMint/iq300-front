Widget = require 'views/base/widget'

class ProjectMembersForm extends Widget
  init: =>
    @resultElement = undefined
    @loading = false
    @sending = false

  bindings: =>
    @form = $ "form", @el
    @form.submit @addUser
    @submitBtn = $ "input[type='submit']", @form
    @submitBtnVal =  @submitBtn.val()
    @enableSubmit()
    @searchInput = $ "input.search", @form
    @existUserIds = @searchInput.data "exists"
    @groupSelect = $ "select#project_membership_group_name", @form
    @groupSelect.unbind "change"
    @groupSelect.change @initilizeSelect2
    @initilizeSelect2()

  initilizeSelect2: =>
    group = @groupSelect.val()
    if group == 'owners'
      url = @searchInput.data 'url-with-community'
      minimumInputLength = 0
    else
      url = @searchInput.data 'url'
      minimumInputLength = 2
    @placeholder = @searchInput.data 'placeholder'
    IQ300.Plugin.use 'select2', =>
      IQ300.Plugin.use 'select2_locale_ru', =>
        @searchInput.select2
          allowClear: true,
          placeholder: @placeholder
          minimumInputLength: minimumInputLength
          ajax:
            url: url
            dataType: "json"
            data: (term, page) ->
              search: term # search term
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

  userFormatResult: (data)=>
    User = require "models/user"
    UserView = require "backbone_views/users/user-view"
    user = new User data
    new UserView(model: user).render().el

  userFormatSelection:(user)=>
    user.name

  disableSubmit: =>
    @sending = true
    @submitBtn.val @submitBtn.data('wait')
    @submitBtn.attr 'disabled','disabled'

  enableSubmit: =>
    @sending = false
    @submitBtn.val @submitBtnVal
    @submitBtn.removeAttr 'disabled'

  addUser: (ev)=>
    ev.preventDefault()
    return false if @sending
    @disableSubmit()
    @data = @form.serialize()
    url = @form.attr 'action'
    @el.addClass 'is-loading'
    $.ajax
      type: 'post',
      url: url,
      data: @data
      success: @draw,
      error: window.errorHandler
      complete: ()=>
        @enableSubmit()
        @el.removeClass 'is-loading'

  reset: =>
    @searchInput.select2 "data", null
    @enableSubmit()

  draw: (response)=>
    if @parent && @resultElement
      data = $ response
      app.initializer.initialize data
      @resultElement.prepend data
      @parent.bindings()
      @reset()

module.exports = ProjectMembersForm