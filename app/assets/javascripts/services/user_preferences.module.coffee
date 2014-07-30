class UserPreferences
  object = null

  config:
    rootKey: 'user_preferences'

  constructor: ->
    store.set(@config.rootKey, {}) unless store.get(@config.rootKey)

  get: (value) =>
    store.get(@config.rootKey)[value]

  set: (key, value) =>
    preferences = store.get(@config.rootKey)
    preferences[key] = value
    store.set(@config.rootKey, preferences)

  clear: =>
    store.remove(@config.rootKey)

  @getSingleton: ->
    object ?= new UserPreferences

module.exports = UserPreferences.getSingleton()