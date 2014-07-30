class window.ProjectDocumentCategoriesView  extends window.CategoriesView
  bindings: =>
    @tags = $ 'a.documents-by-tag', @el
    @tags.click @docsList

  docsList: (ev)=>
    target = $ ev.currentTarget
    ev.stopPropagation()
    ev.preventDefault()
    tag = target.data 'tag'
    isTrashCan = window.projectDocsRouter.getParam 'in_trash_can'
    if isTrashCan == undefined
      isTrashCan = 'false'
    window.projectDocumentsList.active = false
    window.projectDocsRouter.deleteParam 'in_trash_can'
    window.projectDocsRouter.navigate "#{window.projectDocumentsList.url}?tag=#{tag}&in_trash_can=#{isTrashCan}", true

app.initializer.addComponent "ProjectDocumentCategoriesView", 'project-document-categories-view'