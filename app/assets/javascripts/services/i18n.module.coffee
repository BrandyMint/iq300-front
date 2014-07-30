class I18n
  CACHE_EXPIRE_IN: 1000 * 3600 * 8 # 8 hours
  DEFAULT_LOCALE: "ru"

  object = null

  constructor: ->
    @supportsStorage = @supportsHtml5Storage()
    $(window).bind "localeChanged", @initialize
    @initialize()

  initialize: =>
    @currentLocale = $.cookie("locale") || @DEFAULT_LOCALE
    @syncDictionary()

  isCacheExpired: =>
    return true unless @supportsStorage
    if @supportsStorage
      localeData = @_getLocaleDataFromCache()
      return true unless localeData
      syncTime = parseInt(localeData.syncedAt) || 0
      (new Date().getTime() - syncTime) > @CACHE_EXPIRE_IN

  syncDictionary: =>
    if @isCacheExpired()
      $.getJSON "/locales", (data) =>
        @_cacheDictionary data
    else
      @_retriveFromCache()

  _cacheDictionary: (data)=>
    @dictionary = data
    if @supportsStorage
      localeData = { syncedAt: new Date().getTime(), data: @dictionary }
      window.localStorage[@currentLocale] = JSON.stringify localeData

  _getLocaleDataFromCache: =>
    return undefined unless @supportsStorage
    data = window.localStorage[@currentLocale]
    if data then JSON.parse(data) else undefined

  _retriveFromCache: =>
    return undefined unless @supportsStorage
    @dictionary = @_getLocaleDataFromCache().data

  t: =>
    @translate.apply(@, arguments)

  translate: =>
    args = arguments
    path = args[0]
    path = "['#{path.split(".").join("']['")}']"
    try
      res = eval "this.dictionary#{path}"
      throw "undefined" if res is undefined
      if res instanceof Object
        pluralizeCount = _(arguments).last()
        pluralizeKey = @getPluralizeKey pluralizeCount
        res = res[pluralizeKey]
      params = res.match /%{.+?}/g
      if params
        for param, index in params
          res = res.replace param, args[index + 1]
      res
    catch err
      "translation missing " + path

  getPluralizeKey: (n) =>
    switch @currentLocale
      when "ru" then @getPluralizeKeyRu n
      when "en" then @getPluralizeKeyEn n

  getPluralizeKeyEn: (n)=>
    if n is 1
      "one"
    else
      "other"

  getPluralizeKeyRu: (n) =>
    if (n % 10 == 1) && (n % 100 != 11)
      "one"
    else
      if _([2, 3, 4]).include(n % 10) && (!_([12, 13, 14]).include(n % 100))
        "few"
      else
        if (n % 10 == 0) || (_([5, 6, 7, 8, 9]).include(n % 10)) || (_([11, 12, 13, 14]).include(n % 100))
          "many"
        else
          "other"

  supportsHtml5Storage: =>
    try
      return "localStorage" of window and window["localStorage"] isnt null
    catch e
      return false
    return

  @getSingleton: ->
    object ?= new I18n

module.exports = I18n.getSingleton()
