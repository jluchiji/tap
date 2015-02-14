
crypto = require('../lib/crypto.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  self = { }

  self.authenticate = (user, password) ->
    crypto.compare(password, user.hash)
      .then (result) =>
        if not result
          @conveyor.panic('Credentials rejected.', 401)

  self.createToken = (user) ->
    crypto.createToken(user, @config.isSecure ? no)

  return self
