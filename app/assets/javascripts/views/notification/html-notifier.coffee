PERMISSION_DEFAULT = "default"
PERMISSION_GRANTED = "granted"
PERMISSION_DENIED = "denied"
PERMISSION = [PERMISSION_GRANTED, PERMISSION_DEFAULT, PERMISSION_DENIED]

Widget = require 'views/base/widget'

class window.HtmlNotifier extends Widget
  init: =>
    @isSupported = false
    try
      # Safari, Chrome, FF, Firefox mobile
      @isSupported = !!(window.Notification or window.webkitNotifications or window.navigator.mozNotification)
    if @isSupported
      @el.append  $("<audio id='notice-audio'><source src='/audios/notify.wav' type='audio/wav'></audio>")
      @audio = $("audio#notice-audio", @el)[0]
      @redirectUrl = @el.data "redirect-url"
      @permission = "default"

  declOfNum: (number, titles) =>
    cases = [2, 0, 1, 1, 1, 2]
    titles[(if (number % 100 > 4 and number % 100 < 20) then 2 else cases[(if (number % 10 < 5) then number % 10 else 5)])]

  createNotifyText: (count)=>
    arr1 = [app.i18n.t('components.widgets.notification.html_notifier.not_read.one'), app.i18n.t('components.widgets.notification.html_notifier.not_read.many'), app.i18n.t('components.widgets.notification.html_notifier.not_read.many')]
    arr2 = [app.i18n.t('components.widgets.notification.html_notifier.notification.one'), app.i18n.t('components.widgets.notification.html_notifier.notification.few'), app.i18n.t('components.widgets.notification.html_notifier.notification.many')]
    app.i18n.t('components.widgets.notification.html_notifier.you_have') + ' ' + count + ' ' + @declOfNum(count, arr1) + ' ' + @declOfNum(count, arr2)

  sendNotification: (count) =>
    @audio.play()
    theme = app.i18n.t('components.widgets.notification.html_notifier.sender_name')
    params =
      tag: "notify"
      body: @createNotifyText(count)
      icon: "/assets/logo_x1_new.png"
    notice = new Notification(theme, params)
    notice.onshow = =>
      setTimeout (-> notice.close()), 7000
    notice.onclick = =>
      window.open(@redirectUrl, '_blank')

  draw: (response)=>
    if response > 0
      permission = @permissionLevel()
      if permission == "granted"
        @sendNotification(response)
      else
        @requestPermission() if permission == "default"

  checkPermission: (ev)=>
    if @permissionLevel() == "default"
      @requestPermission()

  requestPermission: (ev)=>
    return undefined unless @isSupported
    if window.webkitNotifications and window.webkitNotifications.checkPermission
      window.webkitNotifications.requestPermission()
    else window.Notification.requestPermission()  if window.Notification.requestPermission

  permissionLevel: =>
    permission = undefined
    return  unless @isSupported
    if window.Notification and window.Notification.permissionLevel
      #Safari 6
      permission = window.Notification.permissionLevel()
    else if window.webkitNotifications and window.webkitNotifications.checkPermission
      #Chrome & Firefox with html5-notifications plugin installed
      permission = PERMISSION[window.webkitNotifications.checkPermission()]
    else if window.navigator.mozNotification
      #Firefox Mobile
      permission = PERMISSION_GRANTED
    else if window.Notification and window.Notification.permission
      # Firefox 23+
      permission = window.Notification.permission
    permission

app.initializer.addComponent "HtmlNotifier", 'html-notifier',  (obj)=>
  window.htmlNotifier = obj