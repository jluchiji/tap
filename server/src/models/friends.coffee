# ████████╗ █████╗ ██████╗ ██╗
# ╚══██╔══╝██╔══██╗██╔══██╗██║
#    ██║   ███████║██████╔╝██║
#    ██║   ██╔══██║██╔═══╝ ╚═╝
#    ██║   ██║  ██║██║     ██╗
#    ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝

_       = require('underscore')
squel   = require('squel')

module.exports = (db) ->

  self = { }

  self.find = (user) ->
    query = squel.select()
      .from('friends')
      .field('friends.id')
      .field('friends.accepted')
      .field('users.uname')
      .field('users.id', 'userId')
      .left_join('users', null, 'friends.friendId = users.id')
      .where(
        squel.expr()
          .or('friends.ownerId = ?', user.id)
          .or('friends.friendId = ?', user.id)
      )
    db.all query

  self.add = (uid, user, invitee) ->
    query = squel.insert()
      .into('friends')
      .set('id', uid)
      .set('ownerId', user.id)
      .set('friendId', invitee.id)
    db.run query
      .then -> id: uid, ownerId: user.id, friendId: invitee.id, accepted: 0

  self.remove = (user, friendId) ->
    query = squel.delete()
      .from('friends')
      .where(
        squel.expr()
          .and('ownerId = ?', user.id)
          .and('friendId = ?', friendId)
      )
    db.run query
      .then (result) -> result.changes > 0

  self.accept = (user, friendId) ->
    query = squel.update()
      .table('friends')
      .set('accepted', 1)
      .where(
        squel.expr()
          .and('ownerId = ?', friendId)
          .and('friendId = ?', user.id)
          .and('accepted = 0')
      )
    db.run query
      .then (result) -> result.changes > 0

  return self
