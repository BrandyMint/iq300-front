Router = require('views/base/router')

class window.ContractsRouter extends Router
  routes:
    "communities/:community_id/contracts/:id": "showCommContract"
    "communities/:community_id/contracts": "indexComm"
    "users/:user_id/contracts": "indexUser"
    "users/:user_id/contracts/:id": "showUserContract"

  showCommContract: (community_id, id)=>
    if window.contractView
      window.contractView.show "communities", community_id, id

  showUserContract: (user_id, id)=>
    if window.contractView
      window.contractView.show "users", community_id, id