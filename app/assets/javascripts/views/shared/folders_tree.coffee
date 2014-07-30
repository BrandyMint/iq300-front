class window.FoldersTree
  constructor: (el)->
    @el = $ el
    @treeContainer = @el
    @rootNode =  @el.data('root')

    IQ300.Plugin.use 'tree', (->
      @query = new ServerQueryManager @el.data('url'), @rootNode
      @query.index @renderTree).bind(@)

  renderTree: (data)=>
    treeOptions =
      dragAndDrop: true,
      autoEscape: false,
      autoOpen: false,
      data: data,
      saveState: true,
      selectable: false,
      onCreateLi: @createLi,
      onCanMove: @canMove,
      onCanMoveTo: @onCanMoveTofunction

    @treeContainer.tree treeOptions
    @treeContainer.bind 'tree.open', @openNode
    @treeContainer.bind 'tree.close', @closeNode
    @treeContainer.bind 'tree.move', @moveHandler
    app.initializer.initialize(@treeContainer)

  onCanMoveTofunction: (moved_node, target_node, position)=>
    target_node.id != -1

  moveHandler: (e)=>
    moved = e.move_info.moved_node
    target = e.move_info.target_node
    childData =
      id: moved.id
      folder:
        parent_id: target.id
    @query.update childData, ->


  canMove: (node)=>
    node.type == 'Folder' && node.id != -1

  createLi: (node, li)=>
    if node.type == 'Folder'
      if node.is_open
        icon = 'icon-folder-open-alt'
      else
        icon = 'icon-folder-close-alt'
    else
      icon =  'icon-file-alt'
    li.find('.jqtree-title').before '<i class="' + icon + '"></i>'

  openNode: (event)=>
    el = $ 'i:first', event.node.element
    el.attr 'class', 'icon-folder-open-alt'

  closeNode: (event)=>
    el = $ 'i:first', event.node.element
    el.attr 'class', 'icon-folder-close-alt'

  refresh: ()=>
    @treeContainer.empty()
    @query = new ServerQueryManager @el.data("url")
    @query.index @renderTree


class ServerQueryManager
  constructor: (url, rootNode)->
    @rootNode = rootNode
    @url = url

  update: (data, success)=>
    url = "#{@url}/#{data.id}"
    $.ajax
      type: "PUT"
      url: url
      data: data
      success: success
      dataType: "json"
      error: alert

  index: (success)=>
    if @rootNode
      url = "#{@url}?node=#{@rootNode}"
    else
      url = @url
    $.ajax
      type: "GET"
      url: url
      dataType: "json"
      success: success

  create: (data, success)=>
    $.ajax
      type: "POST"
      url: @url
      data: data
      success: success

app.initializer.addComponent "FoldersTree", "docs-tree"