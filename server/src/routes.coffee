path = require('path')
express = require('express')

module.exports = (db) ->

  # Middleware
  accessCtrl = require('./mware/access-control.js')(db)

  # Load actual handlers for /api
  auth     = require('./api/auth.js')(db)
  users    = require('./api/users.js')(db)
  #projects = require('./api/projects.js')(db)
  #members  = require('./api/members.js')(db)
  #tasks    = require('./api/tasks.js')(db)


  root = express.Router()



  # API Routes
  root.use '/api', api = express.Router()

  # /*
  api.use '*', accessCtrl.tokenParser()

  # /auth
  api.route '/auth'

    # POST /api/auth
    .post auth.create()

    # GET /api/auth
    .get accessCtrl.user()
    .get auth.renew()


  # /user
  api.route '/users'

    # POST /api/users
    .post users.create()


  return root
