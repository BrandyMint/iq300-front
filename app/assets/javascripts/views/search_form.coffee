class window.SearchForm
  constructor: (el)->
    @el = $ el
    @form = $ "form", @el
    @form.submit @search

  search: (ev) =>
    ev.preventDefault()
    searchQuery = $('input#search', @form).val()
    @onSearch? ev, searchQuery
    false

app.initializer.addComponent "SearchForm",
  role: "search-form"
  handler: (obj) => window.searchForm = obj