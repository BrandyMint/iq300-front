class window.NoticeAnimation
  constructor: (el)->
    @el = $ el
    self = @
    hide = (x) -> self.el.fadeOut("slow")

    @el.find('.close').bind('click', hide)
    setTimeout(hide, 7500)

app.initializer.addComponent "NoticeAnimation", "notice-message" #TODO TEMP