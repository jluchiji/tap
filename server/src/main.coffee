express = require 'express'
app     = express()

app.listen 3000, ->
  console.log('Server up and listening on localhost:3000')
