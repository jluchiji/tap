winston = require 'winston'


# --------------------------------------------------------------------------- #
# Socket.io portion of the Tap server.                                        #
# --------------------------------------------------------------------------- #
module.exports = (io) ->
  return (socket) ->

    winston.info 'User Connected'
    winston.info socket.handshake.query
    # Determine user's active group and join the room

    socket.leaveAll() # Kick client from all rooms by default

    socket.on 'join', (data) ->
      winston.info "join: #{data.roomId}"
      if not data.roomId
        winston.warn "Attempt to join without a valid room ID: #{socket.id}"
        return

      socket.leaveAll()
      socket.join(data.roomId)
      winston.info "Client join the group: #{data.roomId}"

    socket.on 'leave', (data) ->
      socket.leaveAll()
      winston.info "Client left all groups"

    socket.on 'tap', (data) ->
      if socket.rooms.length is 0
        winston.warn 'Client not in any rooms, skipping tap event.'
        return # Do not handle tap events without group

      winston.info 'Tap!'
      room = socket.rooms[0]
      socket.broadcast.to(room).emit('tap')
