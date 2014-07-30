$(document).ready ->
  $('body').on 'change', 'input[type=email]', (e) ->
    this.setCustomValidity('')

    unless e.target.validity.valid
      this.setCustomValidity(app.i18n.t('initializers.email_field.not_correct'))