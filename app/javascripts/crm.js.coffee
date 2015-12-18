window.Crm ||= {}

((app) ->
  $(document).ready ->
    $crm = $('@crm-app')
    $container = $('@application-content-wrapper')
    $crm.appendTo $container

)(window.Crm ||= {})
