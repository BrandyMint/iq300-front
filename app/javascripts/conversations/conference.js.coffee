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

  fwdPopoverContent = '<form class="form form-vertical popover-form">
      <input class="popover-form-control" type="text" placeholder="Найти по имени или емэйлу">
        <div class="popover-form-actions">
        <div class="user-block">
        <div class="user-block-content">
        <a href="/users/3" class=" user-block-content-name user-block-content-name-line" role="member-name tooltp" test-task-member-name="true" data-original-title="Эльвир Нуриахметов">
        <img alt="" class="member-box-avatar-image-small conference-members-avatar-image" height="40px" src="https://iq300.s3.amazonaws.com/uploads/user_profile/photo/3/normal_48be0de5-5202-4de4-9852-8b7c9d6d43b4.png" width="40px">
        Эльвир Нуриахметов
        </a>
        </div>
        </div>
      </div>
      </form>'



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
