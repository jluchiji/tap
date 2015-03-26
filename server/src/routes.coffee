path = require('path')
express = require('express')

module.exports = (db) ->

  # Middleware
  accessCtrl = require('./mware/access-control.js')(db)

  # Load actual handlers for /api
  auth     = require('./api/auth.js')(db)
  users    = require('./api/users.js')(db)
  friends  = require('./api/friends.js')(db)
  groups   = require('./api/groups.js')(db)
  members  = require('./api/members.js')(db)


  root = express.Router()



  # API Routes
  root.use '/api', api = express.Router()

  root.use '/docs', express.static __dirname + '/docs'
  root.use '/test', express.static __dirname + '/test-client'
  root.use '/logs', (req, res) -> res.sendFile 'server.log'

  # /*
  api.use '*', accessCtrl.tokenParser()

  # /auth
  api.route '/auth'

    # POST /api/auth
    .post auth.create()

    # GET /api/auth
    .get accessCtrl.user()
    .get auth.renew()

    # DELETE /api/auth
    .delete accessCtrl.user()
    .delete auth.revoke()

  # /user
  api.route '/users'

    # POST /api/users
    .post users.create()

  api.route '/users/:prefix'

    # GET /api/users/:prefix
    .get users.find()

  # /friends
  api.route '/friends'

    .all accessCtrl.user()

    # GET /api/friends
    .get friends.get()

    # POST /api/friends
    .post friends.add()

  api.route '/friends/:id'

    .all accessCtrl.user()

    # DELETE /api/friends/:id
    .delete friends.remove()

    # PUT /api/friends/:id
    .put friends.accept()

  # /groups
  api.route '/groups'

    .all accessCtrl.user()

    # GET /api/groups
    .get groups.list()

    # POST /api/groups
    .post groups.create()

  api.route '/groups/:groupId'

    .all accessCtrl.user()
    .all accessCtrl.group()

    # PUT /api/groups/:groupId
    .put groups.update()

    # DELETE /api/groups/:groupId
    .delete groups.delete()

  api.route '/groups/:groupId/members'

    .all accessCtrl.user()

    # POST /api/groups/:groupId/members
    .post accessCtrl.group()
    .post members.invite()

    # GET /api/groups/:groupId/members
    .get accessCtrl.group()
    .get members.list()

    # PUT /api/groups/:groupId/members
    .put accessCtrl.group(yes) # Allow pending members to access
    .put members.accept()

    # DELETE /api/groups/:groupId/members
    .delete accessCtrl.group()
    .delete members.leave()

  return root
