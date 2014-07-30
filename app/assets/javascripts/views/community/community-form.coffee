Widget = require 'views/base/widget'

class window.CommunityForm extends Widget
  bindings: =>
    @checkbox = $('#community_profile_attributes_is_corporate')
    @corporateSection = $ 'section.corporate', @el
    @noncorporateSection = $ 'section.non-corporate', @el
    @checkbox.on 'change', @corporateSwitch
    @titleInput =  $ 'input#community_title', @el
    setTimeout =>
      @titleInput.focus()
    , 0

    @checkboxCopyLegaladdress = $('#copy_legal_address')
    @checkboxCopyLegaladdress.on 'change', @copyLegalAddress

  corporateSwitch: (e) =>
    target = $ e.currentTarget
    if target.prop('checked')
      @noncorporateSection.hide()
      @corporateSection.show()
    else
      @corporateSection.hide()
      @noncorporateSection.show()
    false

  copyLegalAddress: (e) =>
    target = $ e.currentTarget
    if target.prop('checked')
      $("#community_profile_attributes_corporate_post_region", @el).val $("#community_profile_attributes_corporate_legal_region", @el).val()
      $("#community_profile_attributes_corporate_post_city", @el).val $("#community_profile_attributes_corporate_legal_city", @el).val()
      $("#community_profile_attributes_corporate_post_address", @el).val $("#community_profile_attributes_corporate_legal_address", @el).val()

app.initializer.addComponent "CommunityForm"
