Router = require('views/base/router')

class window.TasksRouter extends Router
  routes:
    "tasks/new": "new"
    "tasks/:id?:params": "show"
    "tasks": "index"
    "communities/:community_id/tasks" : "index"
    "communities/:community_id/tasks/:id?:params": "showCommunityTask"

  showCommunityTask: (communityId, id)=>
    if window.taskView
      window.taskView.show communityId, id

  show: (id)=>
    if window.taskView
      window.taskView.show undefined, id
#    else
#      window.location.reload()
# TODO Кузнецов:
# я не помню, зачем мы это делали, но сейчас это только мешает нам,
# лишний раз перегружая страницу при рендеринге ошибок валдации. В дальнейшем такой проблемы не будет,
# потому что формы отправки мы сделаем аяксовыми и они не будут менять урл,
# но покачто я хочу убрать эту строчку и увидеть причину, почему мы пишем window.location.reload() если нет taskView

  new: =>
