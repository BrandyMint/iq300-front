Router = require('views/base/router')

class window.ProjectDocsRouter extends Router
  routes:
    "projects/:project_id/documents?tag=:tag&in_trash_can=:trashcan" : "index"
    "projects/:project_id/documents" : "index"
    "projects/:project_id/documents/:id" : "show"

  index: (id, tag, trashcan)=>
    if window.projectDocumentsList
      if tag
        window.projectDocsRouter.setParam 'tag', tag
      window.projectDocsRouter.deleteParam 'in_trash_can'
      if trashcan == 'true'
        window.projectDocsRouter.setParam 'in_trash_can', 'true'
      window.projectDocumentsList.refresh()


  show: (project_id, id)=>
    if window.projectDocumentView
      window.projectDocumentView.show id
#    else
#      window.location.reload()
# TODO Кузнецов:
# я не помню, зачем мы это делали, но сейчас это только мешает нам,
# лишний раз перегружая страницу при рендеринге ошибок валдации. В дальнейшем такой проблемы не будет,
# потому что формы отправки мы сделаем аяксовыми и они не будут менять урл,
# но покачто я хочу убрать эту строчку и увидеть причину, почему мы пишем window.location.reload() если нет taskView
