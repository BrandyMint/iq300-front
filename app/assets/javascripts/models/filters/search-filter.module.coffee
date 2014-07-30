Filter = require "models/base/filter"

class SearchFilter extends Filter
  defaults:
    str: ""
    limit: 100

  match: (object, regExp) ->
    str = object.searchString?() ||  object.toString()
    str.match(regExp)?

  use: (objects) ->
    str = _.str.trim(@get "str")
    wordsArr = _(str.split " ").compact()
    regExp = new RegExp(".*#{wordsArr.join(".*")}.*", "i")
    results = []
    for obj in objects
      break if results.length >= @get "limit"
      results.push obj if @match obj, regExp
    results

# HOWTO USE:
# filter = new SearchFilter
# filter.set({str: "hello"})
# results = filter.use(objects)

module.exports = SearchFilter