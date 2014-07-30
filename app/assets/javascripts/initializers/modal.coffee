app.initializers.Modal = (el)->
  targets = $ "div.modal:not(.modal-initialized, .disable-initialize)", el
  if targets.length > 0
    IQ300.Plugin.use 'bootstrap-modal', ->
      targets.each (i, target)->
        new Modal target
        $(target).addClass "modal-initialized"