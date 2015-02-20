# ████████╗ █████╗ ██████╗ ██╗
# ╚══██╔══╝██╔══██╗██╔══██╗██║
#    ██║   ███████║██████╔╝██║
#    ██║   ██╔══██║██╔═══╝ ╚═╝
#    ██║   ██║  ██║██║     ██╗
#    ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝

shortid  = require('shortid')

util     = require('../lib/util.js')
crypto  = require('../lib/crypto.js')
Conveyor = require('../lib/conveyor.js')


module.exports = (db) ->

  users = require('../models/users.js')(db)
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

  self.add = ->
    return (req, res) ->
      schema = id: String

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: 'params.id',
          output: 'invitee',
          users.findById
        .then
          status: 404,
          message: 'User not found.',
          util.exists
        .then
          output: 'uid',
          shortid.generate
        .then
          input: ['uid', 'user', 'invitee'],
          output: 'friendship',
          friends.add
        .then
          status: 201,
          conveyor.success
        .catch conveyor.error
        .done()

  self.remove = ->
    return (req, res) ->
      schema = id: String

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.params)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: ['user', 'params.id'],
          output: 'result',
          friends.remove
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.accept = ->
    return (req, res) ->
      schema = id: String

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.params)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: ['user', 'params.id'],
          output: 'result',
          friends.accept
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
