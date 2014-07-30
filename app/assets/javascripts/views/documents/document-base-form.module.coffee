class DocumentBaseForm
  constructor: (el)->
    @el = $ el
    @form = $ 'form', @el
    @communitySelect = $ 'select#attachment_community_id', @form
    @folderInput = $ 'input#attachment_share_parent_id', @form

    $(window).bind 'docs-community-changed', (event, params)=>
      @setCommunityId params

    $(window).bind 'docs-folder-changed', (event, folderId, communityId)=>
      @setFolderId folderId, communityId

    @bindings()

  bindings: =>
    # template

  setCommunityId: (id='none')=>
    toCompareId = if id == 'none'
                    ''
                  else
                    id + ''
    unless @communitySelect.select2('val') + '' == toCompareId
      @communitySelect.select2 'val', id
      @communitySelect.trigger 'change'

  setFolderId: (id, communityId)=>
    @setCommunityId communityId
    unless @folderInput.select2('val') + '' == id + ''
      @folderInput.select2 'val', id

module.exports = DocumentBaseForm
