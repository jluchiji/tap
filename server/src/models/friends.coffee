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

  return self
