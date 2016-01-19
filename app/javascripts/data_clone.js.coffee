window.DataClone ||= {}

((app) ->
  $(document).ready ->
    toggle = $('@duplicate-element')
    toggle.each ->
      source = $(@).data('source')
      destination = $(@).data('destination')
      $(@).on 'click', () ->
        $s = $(source).last()
        $d = $(destination).first()
        $s.clone().appendTo($d)

)(window.DataClone ||= {})
