class window.OfferForm
  constructor: (form)->
    @form = $ form
    @offer_select = $ '#offer_service_id'
    @parent = $ '#community-services'
    @updateOffersSelect = _.throttle @updateOffersSelect, 500
    @onCreateOfferHandler()
    @onDeleteOfferHandler()

  onCreateOfferHandler: ()=>
    @form.submit ()=>
      if @form.find('select').val()
        $.ajax
          type: @form.attr 'method'
          url: @form.attr 'action'
          data: @form.serialize()
          success: (data)=>
            @renderPartial data
      false

  onDeleteOfferHandler: ()=>
    @parent.find('ul li a.close').click (event)=>
      el = $ event.target
      $.ajax
        type: 'DELETE'
        url: el.attr 'href'
        success: ()=>
          el.parent().remove()
          @checkOffersCount()
          @updateOffersSelect()
      false

  updateOffersSelect: ()=>
    $.ajax
      type: 'GET'
      url: window.location.pathname + '/offers/available'
      success: (data)=>
        @offer_select.html(data)

  renderPartial: (data)=>
    @parent.html data
    app.initializer.initialize @parent

  checkOffersCount: ()->
    if $('#community-services > ul > li').size() == 0
      $('#community-services > p').show()

app.initializer.addComponent 'OfferForm', 'offer-form'
