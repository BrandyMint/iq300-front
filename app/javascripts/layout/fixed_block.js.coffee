window.FixedBlock ||= {}

((app) ->
  $(document).ready ->
    app.$contentGlobal = $('@content-global')
    app.$fixedBlockBottom = $('@fixed-block-bottom')
    $fixedBlockBottomParent = $('@fixed-block-parent-comments')
    fixedBlockClass = 'comments-form-block-fixed'
    app.adjustFixedBlock
      container: app.$contentGlobal
      fixedBlock: app.$fixedBlockBottom
      fixedBlockClass: fixedBlockClass

    $(window).on 'resize', (e) ->
      app.adjustFixedBlock
        container: app.$contentGlobal
        fixedBlock: app.$fixedBlockBottom
        fixedBlockClass: fixedBlockClass

  app.adjustFixedBlock = ({container: container, fixedBlock: fixedBlock, fixedBlockClass: fixedBlockClass}) ->
    return unless container?.length > 0
    containerPosition = {}
    containerPosition = $(container).offset()
    containerPosition.right = $(window).width() - (containerPosition.left + $(container).outerWidth())
    fixedBlock
      .addClass fixedBlockClass
      .css 'left', containerPosition.left + 'px'
      .css 'right', containerPosition.right + 'px'
    if fixedBlock.data('fixed-block-parent')?
      fixedBlockParent = $(fixedBlock.data('fixed-block-parent'))
      #padding = parseInt(fixedBlockParent.css('padding-bottom')) + fixedBlock.height() + 'px'
      #fixedBlockParent.css 'padding-bottom', padding

)(window.FixedBlock ||={})
