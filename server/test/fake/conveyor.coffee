chai = require('chai')
sinon = require('sinon')
assert = chai.assert
should = chai.should()
expect = chai.expect

# Load fake request/response
reqres = require('./req-res.coffee')

fake = module.exports

# Fake conveyor environment for running plugins
fake.ConveyorRun = (config, fn) ->
  return ->
    fakeConveyor =
      request: reqres.Request()
      response: reqres.Response()
      panic: (message, status) ->
        throw new Error(status + '|' + message)
    config ?= { }
    return fn.apply({config: config, conveyor: fakeConveyor}, arguments)
