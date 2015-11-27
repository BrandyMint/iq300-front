window.Conference ||= {}

((app) ->
  $(document).ready ->
    $addBtn = $ '@conference-add-member-btn'
    $settingsBtn = $ '@conference-settings-btn'
    $leaveBtn = $ '@conference-leave-btn'
    $fwdBtn = $ '@conversation-message-fwd'
    appContentBlock = '[role="application-content-block"]'
    appContent = '[role="application-content"]'
    addPop = app.popover $addBtn, addPopoverContent, appContent
    settingsPop = app.popover $settingsBtn, addPopoverContent, appContent
    fwdPop = app.popover $fwdBtn, fwdPopoverContent, appContentBlock
    $(document).on 'click', (e) ->
      for p in [addPop, settingsPop, fwdPop]
        if p? && p.data('bs.popover')? && p.data('bs.popover').$tip?
          if $.inArray(e.target, p) < 0 && $.inArray(p.data('bs.popover').$tip[0], $(e.target).parents()) < 0
            p.popover 'hide'

  addPopoverContent = '<form class="form form-vertical popover-form">
      <input class="popover-form-control" type="text" placeholder="Найти по имени или емэйлу">
        <div class="popover-form-actions">
        <div class="user-block">
        <div class="user-block-avatar">
        <img class="user-block-avatar-image member-box-avatar-image-small img-corrector-initialized" hide_wait_message="true" src="https://iq300.s3.amazonaws.com/uploads/user_profile/photo/2/medium_e641ce02-e837-4d54-beaa-25724ff58b98.jpg" style="width:34px;height:34px;" title="Михайлова Ирина Николаевна">
        <div class="user-block-status-bullet user-status-bullet-offline"></div>
        </div>
        <div class="user-block-content">
        <div class="col-xs-7 col-collapse">
        <a href="/users/2" class=" user-block-content-name user-block-content-name-line" role="member-name" test-task-member-name="true">Шамиль Хамадеев</a>
        <div class="user-block-position user-block-content-name-line">
        hamadeev@mail.com
        </div>
        </div>
        <div class="col-xs-5 col-collapse" role-users-cooperation="ready">
        <a href="/conversations/new?recipient_id=2" class="user-block-add-btn" data-original-title="Написать сообщение" data-role="messenger" role="tooltip" test-write-message="true"><i class="fa fa-plus"></i>
        </a></div>
        </div>
        </div>
        <div class="user-block">
        <div class="user-block-avatar">
        <img class="user-block-avatar-image member-box-avatar-image-small img-corrector-initialized" hide_wait_message="true" src="https://iq300.s3.amazonaws.com/uploads/user_profile/photo/3/normal_48be0de5-5202-4de4-9852-8b7c9d6d43b4.png" style="width:34px;height:34px;" title="Михайлова Ирина Николаевна">
        <div class="user-block-status-bullet user-status-bullet-offline"></div>
        </div>
        <div class="user-block-content">
        <div class="col-xs-7 col-collapse">
        <a href="/users/3" class=" user-block-content-name user-block-content-name-line" role="member-name" test-task-member-name="true">Эльвир Нуриахметов</a>
        <div class="user-block-position user-block-content-name-line">
        elvir@mail.com
        </div>
        </div>
        <div class="col-xs-5 col-collapse" role-users-cooperation="ready">
        <a href="#" class="user-block-added-btn disabled" data-action="add" role="contact-action tooltip" test-create-contact-request="true"><i class="fa fa-check"></i>
        </a>
        <a href="#" class="user-block-remove-btn" data-action="add" role="contact-action tooltip" test-create-contact-request="true"><i class="fa fa-times"></i>
        </a>
        </div>
        </div>
        </div>
      </div>
      </form>'

  fwdPopoverContent = (users) ->
    users ||= []
    usersBlock = fwdPopoverUserBlock() + fwdPopoverConferenceBlock()
    html = "<form class=\"form form-vertical popover-form\">
      <input class=\"popover-form-control\" type=\"text\" placeholder=\"Найти по имени или емэйлу\">
        <div class=\"popover-form-actions\">
          #{usersBlock}
        </div>
      </form>"
    return html

  fwdPopoverUserBlock = (user) ->
    user ||= "Эльвир Нуриахметов"
    html = "<div class=\"user-block\">
        <div class=\"user-block-content\">
          <a href=\"/users/3\" class=\" user-block-content-name user-block-content-name-line\" role=\"member-name tooltp\" test-task-member-name=\"true\" data-original-title=\"Эльвир Нуриахметов\">
            <img alt=\"\" class=\"member-box-avatar-image-small conference-members-avatar-image\" height=\"40px\" src=\"https://iq300.s3.amazonaws.com/uploads/user_profile/photo/3/normal_48be0de5-5202-4de4-9852-8b7c9d6d43b4.png\" width=\"40px\">
            #{user}
          </a>
        </div>
      </div>"
    return html

  fwdPopoverConferenceBlock = (conference) ->
    conference ||= "Шамиль Хамадеев, Эльвир Нуриахметов, Ирина Михайлова и ещё 3 участника"
    html = "<div class=\"user-block\">
        <div class=\"user-block-content\">
        <a class=\" user-block-content-name user-block-content-name-line\">
          <span class=\"message-box-user-avatar conference-message-box-avatars conference-message-box-avatars-horizontal\" href=\"/conversations/conference\">
            <img alt=\"\" class=\"img-circle message-box-user-avatar-image message-box-user-avatar-image-small\" height=\"40px\" src=\"data:image/jpg;base64,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\" width=\"40px\">
            <img alt=\"\" class=\"img-circle message-box-user-avatar-image message-box-user-avatar-image-small\" height=\"40px\" src=\"data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAQDAwQDAwQEAwQFBAQFBgoHBgYGBg0JCggKDw0QEA8NDw4RExgUERIXEg4PFRwVFxkZGxsbEBQdHx0aHxgaGxr/2wBDAQQFBQYFBgwHBwwaEQ8RGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhoaGhr/wAARCAAjACMDASIAAhEBAxEB/8QAGwAAAgIDAQAAAAAAAAAAAAAAAAcFCAIEBgn/xAAvEAABAwMCBAQFBQEAAAAAAAABAgMEAAURBhIHITFRCBMiQRQVMlKRFmFxgcHh/8QAFwEAAwEAAAAAAAAAAAAAAAAAAwQGBf/EACURAAEDAgYBBQAAAAAAAAAAAAEAAgMFIQQREhQxUcETUoGRsf/aAAwDAQACEQMRAD8AbopL8RvEjpzQ10dtECO7frmwdr6WXUoaZV9pWc5UPcAcu+aampFTf09dvkpT8x+De+FKjgeZsO3n7c/eqLcMeHtqv7r8vVkxtBQCpEMyAlxzH1KUPqA/6a0qjUdpHqCUptPONk0qy2hfEhprWVxh2qVGkWm6yl7G0OkLaWrPIBY6H9iBTmqnnEHTulHNMR7rwzhQvjLW+2447AUorHMJ59/UR/FW4t0pUq3RJC1JWt1htalJ6ElIJx/eaFTKmcaw6uR3yiVOm7F4y4P0tqisd9FbHqrG0qMVcmFoUncSkgg8uXaq2SUxdNXRpDlviquseQtt1w+kqRggerHQgjl7g06kXtTkJ2dDtd0mx2SErMaIX1Z7BKck0seLEKYnUlgeTEVCVc7MiYhMyLtUQXVI2uIJyCAE+/LpUNUhLNGHSDLLyrykmLDylrL5+F1Fuh2+4w4MG1QmWkT30MrYabIK1qUAB364pis3NqEy3H8p0eUA2ABk+kY/yozw+WhmNrCHcNVT2URooK2HHEeW05JIwlCfbKQdxJP2039a6Se1Lqt+bG1A1CtaTyjQ7XH8xw7QFFUhYWognJG0JxnqaWozXQsdJnc/iLWXjESNiIsL/KWgv8UjIUr8UU42NI6YYYZbes0KQ4G07nXGdylHAySe9FUO5PuCntpH0UttCISNJRUJSEpKnSQBjJ3Go52DGnXVES4R2psdMhsITJQHvLC87ggqyUA4GQnHSiil8TcX7TMJIGY6TftthttnbQxbYbbDLaMIQMkAZPepMgCOogAYSeg5fiiil4QA1GJJuV5n8buLmuovFTUrEPVV1iR2ZCW22Y8ktNoSltIACU4A6dufU86KKKbAskySv//Z\" width=\"40px\">
            <img alt=\"\" class=\"img-circle message-box-user-avatar-image message-box-user-avatar-image-small\" height=\"40px\" src=\"data:image/png;base64,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\" width=\"40px\">
            <img alt=\"\" class=\"img-circle message-box-user-avatar-image message-box-user-avatar-image-small\" height=\"40px\" src=\"data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAAjACMDASIAAhEBAxEB/8QAGgAAAwADAQAAAAAAAAAAAAAAAAYJBAUIB//EAC0QAAIBAwMCBQMEAwAAAAAAAAECAwQFEQAGIQcSCBMxQVEUImEVQoHhIzOh/8QAGQEAAgMBAAAAAAAAAAAAAAAAAgQDBQYA/8QAJxEAAQQBAQYHAAAAAAAAAAAAAQACBBEDIQUTMUFR8BIyYXGRobH/2gAMAwEAAhEDEQA/AJFW6W3tHLW0LB3du6WUSFiT8sM8fzjWkve4pkuSW+0x1dffJHV4YIQXCY/b2jOQRngDJBzkcaSTUXqCSGSKqe4lQewICs8YyQD3qMj09M/wddz+DKx7gt1+3nvwdKa3qBeYZqUUNE9OI6hRICRKGK8I3cAWC4xzpfPl3OPxVZVlFwmTmGPgOtWuWn3TVW6mppb9b3trM3MLhlkGP3BWGcc+5z8Z05xzUtQFqFjjkLqrCUKMkeo59dVP612Kg6m7XpKOh8OdBVXK7WV0vdwpLqrNZ5Mui9wAAYqyFvMXgHUgXpLvZaS009b51JVUMMcVVTTp2l4yBzg+4BDA/GoYkgSAb0ITs+G6I4VqD6EJ4+tqPajZh7ETKM/90aXUn74+4zMhyRgHgYONGnKVXYWsoLBTyVc0caArnvCpkP8AJPcpB/oaoH4SOtdYvUSDalyt9Na7rabDBb7fXLKypdokkfyRKD6SRghDg5ZRnAxz6p038Ce09v3EVnUPeFZuK5+QfqrfZU+jpIwBlsyNmRsZxkdnqPnT1ufo5tKwUNnsu1OlUb7GrKuSruVZS1k0c9vCRdjT9/3M0nEbKWPAVsZyQey7OzSMRB48tUUGa+JIDi6m81iV163F0y6edRNw7hoZrPa5LY+TUXmard37ndUp42RQgZnbAXOSQPbUhd97qum5t/3jd+4KOmt92qp40mtUcJH0cYiVY40JPKqiqDnByDn8V03J0T2LFY1oK7qxdNzV1wpw1q8mle5PTlWVkqBHB39zYXtHdhQT6jPCdvTwodIeuNTd73tW5bp6Zb1BJu1PebE0cRnfOWaFz2yZ93ikIHrzkaT2fEyOa7KBR4air9rVztqY5+RuMEUNSAb17/VKmO31skCSI1EFZQwH61S8Z9v9nB/Hto12DdfA314o7/U0tDcti3akiISKse6PTNMAB9xiaIlD+Mn8caNPbmX07+Vmd6On2rGUf+USNJ9xnuDJMT+9VI7QfwMk4+Tn11v7Lg22FSOPMYfx3EY0aNaJnmS/JMgp4KZ/KpYY6aL08uFAi8Djgce+l2qjQU0mFA7Xbt/HP96NGpcqjYsFYYXTLwxu2SMsgJwOBo0aNAjoL//Z\" width=\"40px\">
            <img alt=\"\" class=\"img-circle message-box-user-avatar-image message-box-user-avatar-image-small\" height=\"40px\" src=\"data:image/png;base64,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\" width=\"40px\">
          </span>
          #{conference}
          </a>
        </div>
      </div>"
    return html

  app.popover = (el, content, container) ->
    pop = $(el).popover
      template: '<div class="popover-form-block" role="tooltip">
        <div class="arrow"></div>
        <a class="popover-close-btn-inner">&times;</a>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        </div>'
      content: content
      html: true
      placement: 'auto'
      trigger: 'click'
      container: container
    return pop



)(window.Conference ||={})
