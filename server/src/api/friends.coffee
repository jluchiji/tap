shortid  = require('shortid')

util     = require('../lib/util.js')
crypto  = require('../lib/crypto.js')
Conveyor = require('../lib/conveyor.js')


module.exports = (db) ->

  friends = require('../models/friends.js')(db)

  self = { }

  self.get = ->
    return (req, res) ->

      (conveyor = new Conveyor req, res, user: req.authUser)
        .then
          input: 'user',
          output: 'friends',
          friends.find
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
