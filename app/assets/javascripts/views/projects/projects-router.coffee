Router = require('views/base/router')

class window.ProjectsRouter extends Router
  routes:
    'projects/:id?:params': 'show'
    'projects/:id': 'show'

  show: (id, params=undefined)->
    window.projectsView.show id if window.projectsView

  deleteParams: (keys)=>
