$ ->
  Router = require('views/base/router')

  window.tasksRouter = new window.TasksRouter
  window.projectsRouter = new window.ProjectsRouter
  window.communitiesRouter = new window.CommunitiesRouter
  window.notificationsRouter = new window.NotificationsRouter
  window.conversationsRouter = new window.ConversationsRouter
  window.projectDocsRouter = new window.ProjectDocsRouter
  window.contactsRouter = new window.ContactsRouter
  window.contractsRouter = new window.ContractsRouter
  window.activityRouter = new window.ActivityRouter
  window.documentsRouter = new window.DocumentsRouter
  window.appRouter = new Router
