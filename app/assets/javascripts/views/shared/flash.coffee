class window.Flash
  constructor: (text) ->
    $('.content > .notice-message').remove()
    template = $("<div class='notice-message'>#{text}<a href='#' class='icon-remove close'></a></div>")
    template.insertAfter('section.top-panel')
    new window.NoticeAnimation(template)