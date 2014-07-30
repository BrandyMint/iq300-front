class window.MentionsHighlight

  config:
    at: '@'
    selectors:
      comments: '.comments-list'
      comment_body: '.comment.comment-item > .body'
      mentions: 'span.mention.people'
      highlight: 'highlight'
    urls:
      current_user: '/users/current'

  constructor: -> @initialize.apply(@, arguments)

  initialize: (@el) ->
    @_getCurrentUser()
      .done (user) =>
        @highlightMentions(user.pretty_mention_name)

  highlightMentions: (mention_name) ->
    return unless mention_name
    $els = $(@el)
      .filter(@config.selectors.comments)
      .find(@config.selectors.comment_body)
    $els.each (index, el) =>
      $(el)
        .find(@config.selectors.mentions)
        .filter(':contains(' + @config.at + mention_name + ')')
        .addClass(@config.selectors.highlight)

  _fetchCurrentUser: ->
    $.getJSON(@config.urls.current_user)
      .done (response) =>
        @currentUser = response.user

  _getCurrentUser: ->
    dfd = new $.Deferred
    if @currentUser
      dfd.resolve(@currentUser)
    else
      @_fetchCurrentUser()
        .done =>
          dfd.resolve(@currentUser)
    dfd
