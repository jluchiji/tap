path = require('path')
express = require('express')

module.exports = (db) ->

  # Middleware
  #authorize = require('./middleware/authorize.js')(db)

  # Load actual handlers for /api
  #tokens   = require('./api/auth.js')(db)
  users    = require('./api/users.js')(db)
  #projects = require('./api/projects.js')(db)
  #members  = require('./api/members.js')(db)
  #tasks    = require('./api/tasks.js')(db)


  root = express.Router()



  # API Routes
  root.use '/api', api = express.Router()

  # /auth

  # /user
  api.route '/users'

    # POST /api/users
    .post users.create()


  return root
