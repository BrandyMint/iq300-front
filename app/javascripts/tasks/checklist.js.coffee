window.TaskChecklist ||= {}

((app) ->
#  $(document).ready ->
#    checklistItem = $('@task-checklist-item')
    #$srcElement = undefined
    #srcIndex = undefined
    #dstIndex = undefined
    #checklistItem.dragdrop
      #sourceClass: 'task-checklist-item'
      #dragClass: 'task-checklist-item task-checklist-item-dragging'
      #container: $('@task-checklist')
      #sourceHide: true
      #makeClone: true
      #canDrag: ($src, event) ->
        #$srcElement = $src
        #srcIndex = $srcElement.index()
        #dstIndex = srcIndex
        #$src
      #canDrop: ($dst) ->
        #if $dst.is('li')
          #dstIndex = $dst.index()
          #if srcIndex < dstIndex
            #$srcElement.insertAfter $dst
          #else
            #$srcElement.insertBefore $dst
#          true

)(window.TaskChecklist ||={})
