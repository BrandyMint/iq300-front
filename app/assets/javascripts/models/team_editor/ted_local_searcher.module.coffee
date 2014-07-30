SearchFilter = require "models/filters/search-filter"

class TEdLocalSearcher

  constructor: (collection)->
    @collection = collection

  search: (query, callback)=>
    return [] unless @collection
    @model = new SearchFilter unless @model
    setTimeout =>
      @model.set('str', query)
      callback(@model.use(@collection))
    , 100

module.exports = TEdLocalSearcher