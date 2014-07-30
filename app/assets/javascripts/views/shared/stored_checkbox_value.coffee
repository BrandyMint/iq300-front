class window.StoredCheckboxValue
  constructor: (container)->
    @el = $ 'input:checkbox',  container
    @cookieName = @el.data 'cookie-name'
    @value = $.cookie @cookieName
    if @value == 'true'
      @el.prop 'checked', 'checked'
    @el.click @storeChckboxValue

  storeChckboxValue: =>
    if @el.prop 'checked'
      @value = 'true'
    else
      @value = 'false'
    $.cookie(@cookieName, @value, { expires: 30 });
    @el.closest('form').submit()

app.initializer.addComponent 'StoredCheckboxValue', 'storable-checkbox'