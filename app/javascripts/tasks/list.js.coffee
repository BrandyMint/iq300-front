window.TasksList ||={}

((app) ->
  $(document).ready ->
    filtersBlock = $('@tasks-list-filters')
    filter = filtersBlock.find('select')
    resetBtn = filtersBlock.find('@reset-filters')
    filter.on 'change', (e) ->
      resetBtn.show()
    resetBtn.on 'click', (e) ->
      filter.each ->
        $(@).find('option').removeAttr('selected')
        $(@).find('option').first().attr('selected', 'selected')
      $(@).hide()



)(window.TasksList ||={})
