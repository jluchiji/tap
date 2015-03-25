_       = require('underscore')
squel   = require('squel')
winston = require('winston')
msgpack = require('msgpack')
urlsafe = require('urlsafe-base64')
moment  = require('moment')

crypto  = require('../lib/crypto.js')
util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

config  = require('../config/auth-policy.json')

module.exports = (db) ->

  self = _internal: { }

  # ------------------------------------------------------------------------- #
  # Chas authentication token parser. Example token:                          #
  #   lMKoUUphZlNHVjTOVLHc6LhZWng1dVRqU3kybmdQYmJGNGZiY0ZBPT0                 #
  #                                                                           #
  # ------------------------------------------------------------------------- #
  self.tokenParser = ->
    return (req, res, next) ->
      # Use a Conveyor to handle to stuff
      (conveyor = new Conveyor req, res, token: req.headers['x-tap-auth'])
        # Check whether the token looks right
        .then
          input: 'token',
          (token) ->
            if not token
              @conveyor.panic('Missing auth token', 400, ignore: yes)
            unless urlsafe.validate(token)
              @conveyor.panic('Malformed auth token:' + token, 400)
            return token
        # Unpack the token
        .then (token) ->
          meta = msgpack.unpack urlsafe.decode token
          # If meta is not array, auth token is invalid
          if not _.isArray(meta)
            @conveyor.panic('Malformed auth token:' + token, 400)
          else
            return {
              isSecure: meta[0]
              userId: meta[1]
              createdAt: meta[2]
              _signature: meta[3]
              _payload: msgpack.pack(meta.slice(0,-1))
            }
        # Successfully parsed the token, proceed
        .then (token) ->
          req.authToken = token
          next()
        # Token is malformed or missing, print warning and go on
        .catch (error) ->
          if not error.details?.ignore
            winston.warn error.toString()
          req.authToken = null
          next()
        # Throw unhandled errors
        .done()

  # ------------------------------------------------------------------------- #
  # Indicates that the route(s) require user-level authentication.            #
  #                                                                           #
  # type   - (default|secure|any) String indicating required token type.      #
  #                                                                           #
  # ------------------------------------------------------------------------- #
  self.user = (type = 'default') ->
    return (req, res, next) ->
      # Use a Conveyor to handle the stuff
      conveyor = new Conveyor req, res, token: req.authToken
      conveyor
        # Auth token sanity check
        .then
          input: 'token',
          (token) ->
            # Token is undefined only if tokenParser was not called
            if token is undefined
              @conveyor.panic('undefined token: did you load tokenParser?')
            # Token is null only if parsing failed
            if token is null
              @conveyor.panic('Malformed auth token.', 400)
            # Make sure token type matches what is needed
            if type isnt 'any'
              if type is 'default' and token.isSecure
                @conveyor.panic(
                  'Bad auth token type: non-secure token required.', 401
                )
              if type is 'secure' and not token.isSecure
                @conveyor.panic(
                  'Bad auth token type: secure token required.', 401
                )
            return token
        # Find the user by ID
        .then
          output: 'user',
          (token) ->
            db.get squel.select().from('users').where('id = ?', token.userId)
        # Check if user exists
        .then
          status: 404,
          message: 'User not found.',
          util.exists
        # Compute HMAC using user's auth code
        .then
          input: ['token._payload', 'user.auth'],
          output: 'hmac',
          crypto.hmacDigest
        # Verify token signature and TTL
        .then
          input: ['token', 'hmac'],
          (token, hmac) ->
            # Check if signatures match
            if token._signature isnt hmac
              @conveyor.panic('Bad token signature.', 401)
            # Check if token is expired
            ttl = if token.isSecure
              config.general_ttl
            else
              config.secure_ttl
            time = moment().unix() - token.createdAt
            if time > ttl then @conveyor.panic('Auth token expired.', 401)
            # If params includes :userId, check if token belongs to the user
            if req.params.userId and (token.userId isnt req.params.userId)
              @conveyor.panic(
                'Token user ID does not match requested resource owner ID.',
                401
              )
        # No problems, proceed
        .then
          input: 'user',
          (user) ->
            req.authUser = user
            next()
        # Boss, we got a problem!
        .catch
          status: 401,
          message: 'Authorization denied.',
          conveyor.error
        .done()

  # ------------------------------------------------------------------------- #
  # Indicates that the route(s) require group-membership authentication.      #
  #                                                                           #
  # allowPending - If true, also allow pending members to access the API.     #
  #                                                                           #
  # ------------------------------------------------------------------------- #
  self.group = (allowPending = no) ->
    return (req, res, next) ->
      # Use a conveyor to handle the stuff
      conveyor = new Conveyor req, res, user: req.authUser, params: req.params
      conveyor
        # Parameter sanity check
        .then
          input: ['user', 'params'],
          (user, params) ->
            # User is undefined only if user() is not loaded
            if user is undefined
              @conveyor.panic('undefined user: did you load user()?')
            # URL does not contain Group ID, fail
            if not params.groupId
              @conveyot.panic(
                'URL must have :groupId segment for group-level access.'
              )
        # Find the group
        .then
          input: ['params.groupId'],
          output: 'group',
          (id) ->
            db.get squel.select().from('groups').where('id = ?', id)
        # Make sure that the group exists
        .then
          status: 404,
          message: 'Group with the specified ID does not exist.',
          util.exists
        # Find user membership
        .then
          input: ['user', 'params'],
          output: 'membership',
          (user, params) ->
            query = squel.select()
              .from('user_group')
              .field('groups.*')
              .field('user_group.accepted')
              .left_join('groups')
              .where(
                squel.expr()
                  .and('user_group.ownerId = ?', user.id)
                  .and('user_group.groupId = ?', params.groupId)
              )
            return db.get query
        # Make sure the membership exists
        .then
          status: 401,
          message: 'Authorization denied: group membership invalid.',
          util.exists
        # Check if the user is pending and such users are allowed
        .then
          input: 'membership',
          (group) ->
            if not allowPending and group.accepted is 0
              @conveyor.panic(
                'Authorization denied: user must accept invitation.', 400)
        # Go ahead and go on
        .then
          input: 'membership',
          (group) ->
            req.authGroup = group
            next()
        # Report a problem
        .catch conveyor.error
        .done()

  return self
