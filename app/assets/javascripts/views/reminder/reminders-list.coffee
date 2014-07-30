class window.RemindersList
  constructor: (el)->

    @el = $ el

app.initializer.addComponent 'RemindersList', 'reminders-list', (obj)-> window.remindersList = obj