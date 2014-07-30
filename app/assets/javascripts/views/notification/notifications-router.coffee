Router = require('views/base/router')

class window.NotificationsRouter extends Router
  routes:
    "notifications/:id": "show"
    "notifications": "index"

  show: (id)=>
    if window.notificationView
      window.notificationView.show id
#    else
#      window.location.reload()
# TODO Кузнецов:
# я не помню, зачем мы это делали, но сейчас это только мешает нам,
# лишний раз перегружая страницу при рендеринге ошибок валдации. В дальнейшем такой проблемы не будет,
# потому что формы отправки мы сделаем аяксовыми и они не будут менять урл,
# но покачто я хочу убрать эту строчку и увидеть причину, почему мы пишем window.location.reload() если нет taskView

