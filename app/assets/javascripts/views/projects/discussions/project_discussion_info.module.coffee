Widget = require 'views/base/widget'

class ProjectDiscussionInfo extends Widget
  init: (options)=>
    @view ||= options.view
    @header = $('.discussion-header', @el)
    @info = $('.discussion-info', @el)

  bindings: =>
    @header.bind 'click', @view.toggle
    @info.bind 'click', @view.unroll
    $('.discussion-name a', @el).bind 'click', @showObject

  draw: (response)=>
    @header.remove()
    @info.remove()
    @el.prepend(response)
    @init()
    @bindings()

  showObject: (event)->
    pattern = /^\/(tasks|projects)\/.*$/
    event.preventDefault()
    target = $ event.currentTarget
    url = target.attr('href')
    switch url.match(pattern)[1]
      when 'tasks' then window.tasksRouter.navigate "#{url}?inline=true", true
      when 'projects' then $('.tabnav .details a').click()
      else undefined





module.exports = ProjectDiscussionInfo