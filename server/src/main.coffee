# XXX Use source maps for easier debugging
require('source-map-support').install()

# Express.js app
express  = require('express')
app = module.exports.app = express()
http = require('http').Server(app)
io = require('socket.io')(http)


# Other modules
path     = require('path')
chalk    = require('chalk')
winston  = require('winston')

# Set up winston logger
winston.cli()

# If run from Gulp, force chalk color support
if process.env.NODE_ENV is 'gulp'
  chalk.enabled = yes
  chalk.supportsColor = yes
  winston.info 'Forcing chalk color support.'

# Socket.IO
io.on 'connection', require('./socket.js')(io)

# Create database and launch the server
data = require('./data.js')
data.create(
  path.join(__dirname, 'data.sqlite'),
  path.join(__dirname, '/config/schema.sql')
  )
  .then (db) ->

    # Parse HTTP request bodies
    app.use require('body-parser').json()

    # Load routes
    app.use require('./routes.js')(db)

    # Start listening for connections
    server = http.listen process.env.PORT ? 3000, ->
      winston.info(
        'Server listening at http://%s:%s',
        server.address().address, server.address().port
      )

  .done()
