Widget = require 'views/base/widget'

class window.MenuList extends Widget
  bindings: =>
    @items = $ '.menu-item:not(.not-initialize)', @el

  refresh: =>
    @bindings()
    for item in @items
      temp = new MenuItem item
      temp.refresh()

app.initializer.addComponent 'MenuList', 'menu-list', (obj) =>
  window.menuList = obj
