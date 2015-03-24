shortid  = require('shortid')

util     = require('../lib/util.js')
Conveyor = require('../lib/conveyor.js')

module.exports = (db) ->

  groups = require('../models/groups.js')(db)
  members = require('../models/members.js')(db)

  self = { }

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
          conveyor.success
        .catch conveyor.error
        .done()



  return self
