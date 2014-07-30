class window.StatisticDataRange
  constructor: (el)->
    @el = $ el
    @rangeBlock =  $('.dates-select', @el)
    @periodSelect = $('.period', @el)
    @displayRangeBlock()
    @periodSelect.change @displayRangeBlock

  displayRangeBlock: =>
    if @periodSelect.find('option:selected').val() == 'other'
      @rangeBlock.css('display','inline-block')
    else
      @rangeBlock.css('display','none');
app.initializer.addComponent 'StatisticDataRange'
