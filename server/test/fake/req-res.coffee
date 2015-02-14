chai = require('chai')
sinon = require('sinon')
assert = chai.assert
should = chai.should()
expect = chai.expect

# Fake request object with mockup data
fake = module.exports

fake.Request = ->
  return {
    ip: '255.255.255.255'
    method: 'BREW' # RFC 7168 :)
    originalUrl: '/brew/coffee?sugar=true'
    headers: { }
    params: { }
    body: { }
    query: { }
  }

fake.Response = ->
  return {
    statusCode: -1
    data: null

    status: sinon.spy (code) ->
      @statusCode = code
      return @
    send: sinon.spy (data) ->
      @data = data
      return @
  }
