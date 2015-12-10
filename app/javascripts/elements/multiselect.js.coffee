window.MultiselectElements ||={}

((app) ->
  $('@multiselect').multiselect()

  multiselectSelect = $('@multiselect-select')
  multiselectSelect.each ->
    $(@).multiselect
      enableHTML: true
      includeSelectAllOption: $(@).data('include-select-all-option') || false
      buttonClass: $(@).data('button-class') || false
      maxHeight: $(@).data('max-height') || false
      includeSelectAllOption: $(@).data('select-all-option') || false
      selectAllText: $(@).data('select-all-text') || false
      allSelectedText: $(@).data('all-selected-text') || false
      buttonTextAll: $(@).data('button-text-all') || false
      enableFiltering: $(@).data('filtering') || false
      enableCaseInsensitiveFiltering: $(@).data('case-sensitive-filtering') || false
      templates:
        button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"><span class="multiselect-selected-text"></span></button>'
      buttonText: (options, select) ->
        @caretIcon = 'fa fa-caret-down' if !@caretIcon?
        if options.length is 0 || options.length is $(@).find('option').length
          "<i class=\"#{@buttonIcon}\"></i>&nbsp;<span class=\"multiselect-select-text\">#{@buttonTextAll || 'Все'}</span>&nbsp;<i class=\"#{@caretIcon}\"></i>"
        else
          labels = []
          options.each ->
            caption = $(@).text().trim()
            if caption.length > 40
              text = caption.substring(0, 40).trim() + '&hellip;'
            else
              text = caption
            labels.push text
          text = labels.join(", ") + " "
          "<i class=\"#{@buttonIcon}\"></i>&nbsp;<span class=\"multiselect-select-text\">#{text}</span>&nbsp;<i class=\"#{@caretIcon}\"></i>"
      optionLabel: (element) =>
        bulletColor = $(element).data('bullet-color')
        unless bulletColor?.length > 0
          bulletColor = '#2a6b88'
        if $(@).data('show-option-bullets')
          "<i class=\"multiselect-option-bullet\" style=\"background-color: #{bulletColor}\"></i>&nbsp;#{$(element).html()}"
        else if $(@).data('show-only-bullets')
          "<i class=\"multiselect-option-bullet\" style=\"background-color: #{bulletColor}\"></i>"
        else
          $(element).html()

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

  multiselectColorpicker = $('@multiselect-color-picker')
  multiselectColorpicker.each ->
    $(@).multiselect
      enableHTML: true
      includeSelectAllOption: $(@).data('include-select-all-option') || false
      buttonClass: $(@).data('button-class') || false
      maxHeight: $(@).data('max-height') || false
      includeSelectAllOption: $(@).data('select-all-option') || false
      selectAllText: $(@).data('select-all-text') || false
      allSelectedText: $(@).data('all-selected-text') || false
      buttonTextAll: $(@).data('button-text-all') || false
      enableFiltering: $(@).data('filtering') || false
      enableCaseInsensitiveFiltering: $(@).data('case-sensitive-filtering') || false
      templates:
        button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"><span class="multiselect-selected-text"></span></button>'
        li: '<li class="multiselect-color-picker-list-item"><a tabindex="0"><label></label></a></li>'
        ul: '<ul class="multiselect-container dropdown-menu multiselect-color-picker-container"></ul>'
      buttonText: (options, select) ->
        @caretIcon = 'fa fa-caret-down' if !@caretIcon?
        if options.length is 0 || options.length is $(@).find('option').length
          "<i class=\"#{@buttonIcon}\"></i>&nbsp;<span class=\"multiselect-select-text\">#{@buttonTextAll || 'Все'}</span>&nbsp;<i class=\"#{@caretIcon}\"></i>"
        else
          bulletColor = $(select).find('option:selected').first().val()
          unless bulletColor?.length > 0
            bulletColor = ''
          bullet = "<i class=\"multiselect-color-picker-option\" style=\"background-color: #{bulletColor}\"></i>"
          "<i class=\"#{@buttonIcon}\"></i>&nbsp;<span class=\"multiselect-select-text\">" + bullet + "</span>&nbsp;<i class=\"#{@caretIcon}\"></i>"


      optionLabel: (element) =>
        bulletColor = $(element).val()
        unless bulletColor?.length > 0
          bulletColor = ''
        "<i class=\"multiselect-color-picker-option\" style=\"background-color: #{bulletColor}\"></i>"


)(window.MultiselectElements ||= {})
