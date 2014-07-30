class window.FavoriteView
  constructor: (el)->
    @el = $ el
    $("a", @el).click (e) ->
      e.stopPropagation()
      e.preventDefault()
      $this = $(this)
      method = $this.attr("data-method")
      $.ajax
        url: $this.attr('href')
        type: method
        success: (data) =>
          $this.parent().toggleClass("starred")
          if method == "put"
            $this.attr("data-method", "delete")
            $this.find('span').removeClass('icon-star-empty')
            $this.find('span').addClass('fa-star')
          else
            $this.attr("data-method", "put")
            $this.find('span').removeClass('fa-star')
            $this.find('span').addClass('icon-star-empty')

app.initializer.addComponent "FavoriteView", 'favorite-view'

class window.FavoriteListItem
  constructor: (el)->
    @el = $ el
    @active = @el.data("active") != undefined
    @url = @el.data "url"
    @el.click @send
    @refresh()

  send: =>
    method = if @active then "delete" else "put"
    $.ajax
      url: @url
      type: method
      success: (data) =>
        @active = !@active
        @refresh()
    no

  refresh: =>
    @el.removeClass "fa-star-o fa-star"
    unless @active
      @el.addClass "fa-star-o"
    else
      @el.addClass "fa-star"
