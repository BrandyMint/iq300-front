window.errorHandler = (xhr, makeAlert = true, handler )->
  data = JSON.parse(xhr.responseText)
  msg = app.i18n.t('components.error_handler.any_errors') + "\n"
  for key of data
    objectErrors = data[key]
    if key == "error"
      msg += objectErrors
    else
      msg += "#{t("activerecord.models.#{key}.one")}:\n"
      for attr of objectErrors
        for errorStr in objectErrors[attr]
          msg += "#{t("activerecord.attributes.#{key}.#{attr}")} #{errorStr}\n"
  if makeAlert
    container = $("<span class='flash-error'></span>").html(msg)
    container.purr()
  handler?(msg)





