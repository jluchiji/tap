_       = require('underscore')
shortid = require('shortid')
squel   = require('squel')

module.exports = (db) ->

  self = { }

  self.invite = (group, user) ->
    accept = if @config?.accept then 1 else 0
    uid = shortid.generate()
    query = squel.insert()
      .into('user_group')
      .set('id', uid)
      .set('ownerId', user.id)
      .set('groupId', group.id)
      .set('accepted', accept)
    db.run query
      .then -> id: uid, owner: user.id, group: group.id, accepted: accept

  self.accept = (group, user) ->
    query = squel.update()
      .table('user_group')
      .where('ownerId = ? AND groupId = ?', user.id, group.id)
      .set('accepted', 1)
    db.run query

  self.leave = (group, user) ->
    query = squel.delete()
      .from('user_group')
      .where('ownerId = ? AND groupId = ?', user.id, group.id)
    db.run query

  return self
