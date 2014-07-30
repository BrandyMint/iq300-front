app.initializers.SelectTwo = (el)->
  targets = $ "input.select-two:not(.select-two-initialized, .disable-initialize), select.select-two:not(.select-two-initialized, .disable-initialize)", el
  if targets.length > 0
    targets.each (i, target)->
      new SelectTwo target
      $(target).addClass "select-two-initialized"