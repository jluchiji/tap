util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  groups = require('../models/groups.js')(db)
  members = require('../models/members.js')(db)

  self = { }

  self.invite = ->
    return (req, res) ->

      schema = user: String
      query = groupId: String

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body, query: req.params)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: 'query',
          schema: query,
          util.schema
        .then
          input: 'query.groupId',
          output: 'group',
          groups.find
        .then
          input: 'group',
          util.exists
        .then
          input: ['group', 'user'],
          output: 'membership',
          members.invite
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.accept = ->
    return (req, res) ->

      query = groupId: String

      (conveyor = new Conveyor req, res, user: req.authUser, query: req.params)
        .then
          input: 'query',
          schema: query,
          util.schema
        .then
          input: ['user', 'query.groupId'],
          members.accept
        .then
          input: 'nothing',
          conveyor.success
        .catch conveyor.error
        .done()

  return self
