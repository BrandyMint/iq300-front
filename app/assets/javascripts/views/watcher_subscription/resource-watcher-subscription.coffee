class window.ResourceWatcherSubscription
  constructor: (el)->
    @el = $(el)
    @checkbox = $ 'input[type=checkbox]', @el
    @checkbox.change @submit
    @url = @el.data "url"

#  если отметили - пост, удалили - делете
  submit: (e)=>
    e.preventDefault()
    method = if @checkbox.is(':checked') then 'POST' else 'DELETE'
    $.ajax
      type: method
      url: @url
      error: window.errorHandler

app.initializer.addComponent "ResourceWatcherSubscription"