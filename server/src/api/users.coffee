shortid  = require('shortid')

util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

crypto  = require('../lib/crypto.js')

module.exports = (db) ->

  auth = require('../models/auth.js')(db)
  users = require('../models/users.js')(db)

  self = { }

  self.create = ->
    return (req, res) ->

      # Schema for required parameters
      schema =
        username: /^[\w]{6,}$/
        password: String

      # Pipeline
      (conveyor = new Conveyor req, res, params: req.body)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          output: 'uid',
          shortid.generate
        .then
          output: 'auth',
          crypto.generateAuth
        .then
          input: 'params.password',
          output: 'hash',
          crypto.bcryptHash
        .then
          input: ['uid', 'params.username', 'hash', 'auth'],
          output: 'user',
          users.create
        .then
          output: 'user.token',
          auth.createToken
        .then
          input: 'user',
          users.sanitize
        .then
          status: 201,
          conveyor.success
        .catch conveyor.error
        .done()

  self.find = ->
    return (req, res) ->
      # Schema for required parameters
      schema = username:  /^[\w]{6,}$/

      # Start the Conveyor
      (conveyor = new Conveyor req, res, params: req.params)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: 'params.username',
          output: 'user',
          users.findByUname
        .then
          status: 404,
          message: 'User not found.',
          util.exists
        .then users.sanitize
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
