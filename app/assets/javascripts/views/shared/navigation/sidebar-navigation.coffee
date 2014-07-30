class window.SidebarNavigation
  constructor: (container)->
    @container = container
    @el = $ "#sidebar-navigation", @container
    return if @el.length == 0
    # old code
    @projectsLink = $ "a[href='#menu_tasks']", @el
    @tasksLink = $ "a[href='#menu_projects']", @el

    @newProjectsBtn = $ "#new_tasks", @el
    @newTasksBtn = $ "#new_projects", @el

    @projectsLink.hover =>
      @newProjectsBtn.stop().show()
    , =>
      @newProjectsBtn.stop().hide()

    @tasksLink.hover =>
      @newTasksBtn.stop().show()
    , =>
      @newTasksBtn.stop().hide()

    newBtns = $ ".new-btn", @el
    newBtns.hide()

    newBtns.hover (ev)->
      target = $(ev.currentTarget).stop().show()
      $("i", target).toggleClass "icon-white"
    , (ev)->
      target = $(ev.currentTarget).stop().hide()
      $("i", target).toggleClass "icon-white"

    # issue stories/43699627
    @dropDown = $ "a.drop-down", @container
    @dropDownContent = $ ".drop-down-content", @container
    @dropDown.click @toggleDropDown
    @icon = $ "i", @dropDown
    @icon.addClass "icon-chevron-up"

  toggleDropDown: =>
    @open = true if @open == undefined
    @open = !@open
    if (@open)
      @dropDownContent.animate {height: "+=#{@blockHeight}px"}, 300, =>
        @dropDownContent.css "height", "auto"
        @dropDownFinish()
    else
      @blockHeight = @dropDownContent.height()
      @dropDownContent.animate {height: "-=#{@blockHeight}px"}, 300, @dropDownFinish

    false
  dropDownFinish: =>
    @icon.toggleClass("icon-chevron-up", @open).toggleClass "icon-chevron-down", !@open

app.initializer.addComponent "SidebarNavigation", "sidebar-navigation-container"