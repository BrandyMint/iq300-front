Model = require "models/base/model"

class Filter extends Model
  use: (objects)=>
    _(objects).filter (obj) =>
      @match obj

  match: ->
    true # template method

module.exports = Filter