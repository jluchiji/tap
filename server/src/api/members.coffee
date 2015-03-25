util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  users  = require('../models/users.js')(db)
  groups = require('../models/groups.js')(db)
  members = require('../models/members.js')(db)

  self = { }

  self.list = ->
    return (req, res) ->

      (conveyor = new Conveyor req, res, group: req.authGroup)
        .then
          input: 'group',
          members.list
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.invite = ->
    return (req, res) ->

      schema = user: String

      (conveyor = new Conveyor req, res,
        user:   req.authUser,
        params: req.body,
        group:  req.authGroup
      )
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: 'params.user',
          output: 'invitee',
          users.findById
        .then
          status: 400,
          message: 'User does not exist.',
          util.exists
        .then
          input: ['group', 'invitee'],
          output: 'membership',
          members.find
        .then
          input: 'membership',
          (membership) ->
            if membership then @conveyor.panic(
              'Cannot invite an existing member.', 400
            )
        .then
          input: ['group', 'invitee'],
          output: 'membership',
          members.invite
        .then
          status: 201,
          conveyor.success
        .catch conveyor.error
        .done()

  self.accept = ->
    return (req, res) ->

      (conveyor = new Conveyor req, res,
        user: req.authUser,
        group: req.authGroup
      )
        .then
          input: ['group', 'user'],
          members.accept
        .then
          input: 'group',
          output: 'group.members',
          members.list
        .then
          input: 'group',
          conveyor.success
        .catch conveyor.error
        .done()

  self.leave = ->
    return (req, res) ->

      (conveyor = new Conveyor req, res,
        user: req.authUser,
        group: req.authGroup
      )
        .then
          input: ['group', 'user'],
          members.leave
        .then output: 'result', -> yes
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
