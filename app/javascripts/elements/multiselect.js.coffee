window.MultiselectElements ||={}

((app) ->
  $('@multiselect').multiselect()

  multiselectSelect = $('@multiselect-select')
  multiselectSelect.multiselect
    includeSelectAllOption: $(@).data('include-select-all-option') || false
    selectAllText: $(@).data('select-all-text') || false
    buttonClass: $(@).data('button-class') || false
    maxHeight: $(@).data('max-height') || false
    includeSelectAllOption: $(@).data('select-all-option') || false
    enableFiltering: $(@).data('filtering') || false
    enableCaseInsensitiveFiltering: $(@).data('case-sensitive-filtering') || false
    buttonText: (options, select) ->
      @caretIcon = 'fa fa-caret-down' if !@caretIcon?
      if options.length is 0 || options.length is $(@).find('option').length
        "<i class=\"#{@buttonIcon}\"></i>&nbsp; #{@buttonTextAll || 'Все'} <i class=\"#{@caretIcon}\"></i>"
      else
        labels = []
        options.each ->
          labels.push $(@).text()
        text = labels.join(", ") + " "
        "<i class=\"#{@buttonIcon}\"></i>&nbsp; #{text} <i class=\"#{@caretIcon}\"></i>"

  multiselectTaskStates = $('@multiselect-task-states')
  multiselectTaskStates.multiselect
    includeSelectAllOption: true
    selectAllText: 'Все задачи'
    buttonClass: $(@).data('button-class') || 'btn btn-default'
    buttonText: (options, select) ->
      if options.length is 0 || options.length is multiselectTaskStates.find('option').length
        "<i class=\"fa fa-list\"></i>&nbsp; Все задачи <b class=\"caret\"></b>"
      else
        labels = []
        options.each ->
          labels.push $(@).text()
        labels.join(", ") + " "

  multiselectUsers = $('@multiselect-users')
  multiselectUsers.multiselect
    maxHeight: 200
    includeSelectAllOption: true
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    selectAllText: 'Все исполнители'
    buttonClass: $(@).data('button-class') || 'btn btn-default'
    buttonText: (options, select) ->
      if multiselectUsers.find('option:selected').length is 0 || multiselectUsers.find('option:selected').length is multiselectUsers.find('option').length
        "<i class=\"fa fa-user\"></i>&nbsp; Все исполнители <b class=\"caret\"></b>"
        #else if options.length is 0
        #"<i class=\"fa fa-user\"></i> Все"
      else
        "<i class=\"fa fa-user\"></i>&nbsp; Исполнители: " + options.length + " <b class=\"caret\"></b>"

  multiselectCommunities = $('@multiselect-communities')
  multiselectCommunities.multiselect
    maxHeight: 200
    includeSelectAllOption: true
    enableFiltering: true
    enableCaseInsensitiveFiltering: true
    selectAllText: 'Все сообщества'
    buttonClass: $(@).data('button-class') || 'btn btn-default'
    buttonText: (options, select) ->
      if multiselectCommunities.find('option:selected').length is 0 || multiselectCommunities.find('option:selected').length is multiselectCommunities.find('option').length
        "<i class=\"fa fa-user\"></i>&nbsp; Все сообщества <b class=\"caret\"></b>"
        #else if options.length is 0
        #"<i class=\"fa fa-user\"></i> Все"
      else
        "<i class=\"fa fa-user\"></i>&nbsp; Сообщества: " + options.length + " <b class=\"caret\"></b>"


)(window.MultiselectElements ||= {})
