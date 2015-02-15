window.CommentForm ||= {}

((app) ->
  $(document).ready ->
    return unless Modernizr.draganddrop
    $form = $('@comment-form')
    $form.css 'height', $form.height() + 'px'
    formDragClass = 'comments-form-drag'
    $formContent = $('@comment-form-content')
    $tipDrag = $('@comment-form-tip-drag')
    $tipRelease = $('@comment-form-tip-release')
    $uploadBlock = $('@comment-form-upload-block')
    $uploadProgress = $('@comment-form-upload-progress')
    $form.on 'dragover', (e) ->
      e = e || event
      $form.addClass formDragClass
      $formContent.hide()
      $tipDrag.hide()
      $tipRelease.show()
      e.preventDefault()
      e.stopPropagation()
    $form.on 'drop', (e) ->
      e = e || event
      $uploadBlock.show()
      $form.removeClass formDragClass
      $formContent.show()
      $tipDrag.hide()
      $tipRelease.hide()
      $uploadProgress.animate
        width: "100%"
      , 1500, ->
        setTimeout(( ->
          $uploadProgress.css 'width', '0%'
          $uploadBlock.hide()
          return
        ), 1000)
      e.preventDefault()
      return false

    $(window).on 'dragover', (e) ->
      e = e || event
      e.preventDefault()
      $form.addClass formDragClass
      $formContent.hide()
      $tipDrag.show()
      $tipRelease.hide()
      return false
    $(window).on 'drop', (e) ->
      e = e || event
      e.preventDefault()
      $uploadBlock.show()
      $form.removeClass formDragClass
      $formContent.show()
      $tipDrag.hide()
      $tipRelease.hide()
      return false





)(window.CommentForm ||= {})
