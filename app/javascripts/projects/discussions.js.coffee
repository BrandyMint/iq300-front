$ ->
  projectDiscussions = $('@project-discussion')
  projectDiscussions.on 'click', (e) ->
    e.preventDefault()
    projectDiscussions.each ->
      projectDiscussionRoll($(@))
    discussion = $(@)
    projectDiscussionUnroll(discussion)

  projectDiscussionUnroll = (discussion) ->
    discussion.removeClass 'rolled'
    counter = discussion.find('@project-discussion-comments-counter')
    hideCommentsBtn = discussion.find('@project-discussion-comments-hide')
    counter.hide()
    hideCommentsBtn.show()
    $('#project-tab-pane').scrollTop(discussion.position().top)
    hideCommentsBtn.on 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      projectDiscussionRoll(discussion)

  projectDiscussionRoll = (discussion) ->
    counter = discussion.find('@project-discussion-comments-counter')
    hideCommentsBtn = discussion.find('@project-discussion-comments-hide')
    hideCommentsBtn.hide()
    counter.show()
    discussion.addClass 'rolled'


