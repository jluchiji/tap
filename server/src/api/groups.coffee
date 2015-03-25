shortid  = require('shortid')

util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  groups = require('../models/groups.js')(db)
  members = require('../models/members.js')(db)

  self = { }

  self.list = ->
    return (req, res) ->
      (conveyor = new Conveyor req, res, user: req.authUser)
        .then
          input: 'user',
          output: 'groups',
          groups.list
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.create = ->
    return (req, res) ->

      schema = name: String

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          output: 'uid',
          shortid.generate
        .then
          input: ['uid', 'params.name'],
          output: 'group',
          groups.create
        .then
          input: ['group', 'user'],
          accept: yes,
          members.invite
        .then
          input: 'group',
          status: 201,
          conveyor.success
        .catch conveyor.error
        .done()

  self.update = ->
    return (req, res) ->

      schema = name: String

      (conveyor = new Conveyor req, res,
        user: req.authUser,
        params: req.body,
        group: req.authGroup
      )
        .then
          input: 'params',
          schema: schema,
          util.schema
        .then
          input: ['group.id', 'params.name']
          output: 'group',
          groups.update
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.delete = ->
    return (req, res) ->

      (conveyor = new Conveyor req, res, group: req.authGroup)
        .then
          input: 'group.id',
          groups.delete
        .then output: 'result', -> yes
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
