_       = require('underscore')
squel   = require('squel')

module.exports = (db) ->

  self = { }

  self.findByUname = (uname) ->
    query = squel.select()
      .from('users')
      .where('uname = ?', uname)
    db.get query

  self.findById = (id) ->
    query = squel.select()
      .from('users')
      .where('id = ?', id)
    db.get query

  self.create = (id, uname, hash, auth) ->
    query = squel.insert()
      .into('users')
      .set('id', id)
      .set('uname', uname)
      .set('hash', hash)
      .set('auth', auth)
    db.run(query).then ->
      return {id: id, uname: uname, hash: hash, auth: auth}

  self.update = (user, params) ->
    query = squel.update()
      .table('users')
      .where('id = ?', user.id)

    if params.hash then query = query.set('hash', params.hash)
    if params.auth then query = query.set('auth', params.auth)

    db.run(query).then ->
      _.extend user, params

  self.sanitize = (user) ->
    return _.omit user, 'auth', 'hash'

  return self
