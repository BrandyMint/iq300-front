class window.ComplaintView
  constructor: (el)->
    @container = $ el
    @link = $(".add-complaint", $ el)
    @link.click @addClick

  addClick: (e)=>
    e.preventDefault()
    url = @link.attr('href')
    $.get url, @success


  success: (data) =>
    @container.append(data)
    @container.find('.cancel').click @cancelClick
    @container.find('input:submit').click @submitClick
    @container.find('select').change @selectChange
    @container.find('.select-two').select2({width:'100%'})

  cancelClick: (e) =>
    e.preventDefault()
    @container.find('.new-complaint').remove()

  submitClick: (e)=>
    e.preventDefault()
    $form = @container.find('form')
    $.post($form.attr('action'), $form.serialize(), @submitSuccess).fail @submitFail

  selectChange: =>
    text = @container.find('select option:selected').data('details')
    @container.find('.complaint-type-details').text(text || '')

  submitSuccess: =>
    @link.replaceWith(app.i18n.t('components.widgets.complaints.view.complaint_will_be_saw'))
    @container.find('div.new-complaint').remove()

  submitFail: (data) =>
    @container.find('.errors').html(data.responseText)

app.initializer.addComponent "ComplaintView"
