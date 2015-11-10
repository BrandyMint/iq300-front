window.Auth ||= {}

((app) ->
  $(document).ready ->
    $phoneField = $('@sign-up-phone')
    $phoneFieldBtn = $('@sign-up-phone-btn')
    $phoneFieldCode = $('@sign-up-phone-code')
    $phoneCodeInput = $('@sign-up-phone-code-input')
    $submitBtn = $('@signup-submit-btn')
    $phoneField.on 'keyup keypress blur change', (e) ->
      $phoneFieldBtn.show()
    $phoneFieldBtn.on 'click', (e) ->
      e.preventDefault()
      $phoneFieldCode.show()
    $phoneCodeInput.on 'keyup keypress blur change', (e) ->
      $submitBtn.removeAttr 'disabled'

)(window.Auth ||= {})
