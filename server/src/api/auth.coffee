util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  auth = require('../models/auth.js')(db)
  users = require('../models/users.js')(db)

  self = { }


  # Error message that gets returned to client instead of
  # actual server-side error.
  errorMessage = status: 401, message: 'Authorization denied.'

  # Verifies user credentials and
  self.create = ->
    return (req, res) ->
      # Schema for required parameters
      schema =
        username: /^[\w]{6,}$/
        password: String

      # Start the Conveyor
      (conveyor = new Conveyor req, res, params: req.body)
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
          message: 'User not found',
          util.exists
        .then
          input: ['user', 'params.password'],
          auth.authenticate
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken
        .then
          input: 'user',
          users.sanitize
        .then conveyor.success
        .catch errorMessage, conveyor.error
        .done()

  # Generates a new token for the authorized user
  self.renew = ->
    return (req, res) ->
      #Start the Conveyor
      (conveyor = new Conveyor req, res, user: req.authUser)
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken
        .then
          input: 'user',
          users.sanitize
        .then conveyor.success
        .catch errorMessage, conveyor.error
        .done()

  # Revoke all self for the authorized user, then respond with a new token
  self.revoke = ->
    return (req, res) ->
      #Start the Conveyor
      (conveyor = new Conveyor req, res, user: req.authUser)
        .then
          output: 'params.auth',
          crypto.generateAuth
        .then
          input: ['user', 'params'],
          users.update
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken
        .then
          input: 'user',
          users.sanitize
        .then conveyor.success
        .catch errorMessage, conveyor.error
        .done()

  return self
