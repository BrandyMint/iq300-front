class window.MentionsInput

  config:
    elSelector: 'textarea.comment-body'
    people:
      search_key: 'search_name'
      at: '@'
      tpl: "
        <li data-value='${atwho-at}${mention_name}'>
          <img class='avatar' src='${avatar}'/>
          ${name}
          (@${mention_name})
        </li>
      "

  constructor: (el, @readyCallback) ->
    @$els = $(el).filter(@config.elSelector)
    @$els.each (index, el) =>
      url = $(el).parents('form')?.data('users-path')
      @_getUsers(url)  if url?


  initPeople: (@people) ->
    @_formatUsersData()
    params = $.extend {}, @config.people, { data: @people }
    @initAtWho params

  initAtWho: (params) ->
    IQ300.Plugin.use 'atwho',  =>
      @$els.atwho params
      @readyCallback?()

  _getUsers: (url) ->
    $.getJSON(url)
      .done (response) =>
        @initPeople(response.users)


  _formatUsersData: ->
    _.each @people, (user) ->
      user['avatar'] = user.photo?.thumb || '#'
      user['search_name'] = [user['name'], user['mention_name']].join(' ')

app.initializer.addComponent MentionsInput
