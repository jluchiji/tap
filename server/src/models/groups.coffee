_       = require('underscore')
squel   = require('squel')

module.exports = (db) ->

  self = { }

  self.list = (user) ->
    query = squel.select()
      .from('user_group')
      .field('groups.*')
      .field('user_group.accepted')
      .left_join('groups', null, 'user_group.groupId = groups.id')
      .where('user_group.ownerId = ?', user.id)
    db.all query

  self.find = (id) ->
    query = squel.select()
      .from('groups')
      .where('id = ?', id)
    db.get query

  self.create = (id, name) ->
    query = squel.insert()
      .into('groups')
      .set('id', id)
      .set('name', name)
    db.run query
      .then -> id: id, name: name

  self.update = (id, name) ->
    query = squel.update()
      .table('groups')
      .set('name', name)
      .where('id = ?', id)
    db.run query
      .then -> id: id, name: name

  self.delete = (id) ->
    query = squel.delete()
      .from('groups')
      .where('id = ?', id)
    db.run query

  return self
