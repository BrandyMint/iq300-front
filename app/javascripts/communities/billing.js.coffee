window.CommunityBilling ||={}

((app) ->
  $(document).ready ->
    $billing = $('@community-billing-info')
    $changePlan = $('@community-billing-change-plan')
    $changePlanBtn = $('@change-plan-btn')
    $changePlanConfirm = $('@change-plan-confirm')
    $changePlanConfirmUpgrade = $('@change-plan-confirm-upgrade')
    $changePlanConfirmBtn = $('@change-plan-confirm-btn')
    $planSelectBtn = $('@plan-select-btn')

    $changePlan.fadeOut()
    $changePlanConfirm.fadeOut()
    $changePlanConfirmUpgrade.fadeOut()

    $changePlanBtn.on 'click', (e) ->
      e.preventDefault()
      $billing.fadeOut()
      $changePlan.fadeIn()
      $changePlanConfirm.fadeOut()
      $changePlanConfirmUpgrade.fadeOut()

    $planSelectBtn.on 'click', (e) ->
      e.preventDefault()
      $billing.fadeOut()
      $changePlan.fadeOut()
      if $(@).data('upgrade')?
        $changePlanConfirmUpgrade.fadeIn()
      else
        $changePlanConfirm.fadeIn()

    $changePlanConfirmBtn.on 'click', (e) ->
      e.preventDefault()
      $billing.fadeIn()
      $changePlan.fadeOut()
      $changePlanConfirm.fadeOut()
      $changePlanConfirmUpgrade.fadeOut()


)(window.CommunityBilling ||={})
