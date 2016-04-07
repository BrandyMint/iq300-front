window.Docs ||= {}

((app) ->
  $item = $('@docs-list-item')
  $header = $('@docs-list-header')
  $headerMenu = $('@docs-list-header-menu')

  $item.on 'change', (e) ->
    $itemSelected = $item.find('input:checked')
    if $itemSelected.length > 0
      $header.hide()
      $headerMenu.show()
    else
      $header.show()
      $headerMenu.hide()

)(window.Docs ||= {})

