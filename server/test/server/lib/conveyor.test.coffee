chai = require('chai')
sinon = require('sinon')
assert = chai.assert
should = chai.should()
expect = chai.expect

# Disable winston logging for the test
require('winston').warn = -> undefined

# Load fixtures and tested class
fake = require('../../fake/req-res.coffee')
Conveyor = require('../../../dist/lib/conveyor.js')


describe 'ChasConveyor', ->

  it '#constructor() should correctly assign parameters', ->
    conveyor = new Conveyor({req: 'data'}, {res: 'data'}, {prop: 'value'})

    expect(conveyor).to.have.property('request').that.deep.equals(req: 'data')
    expect(conveyor).to.have.property('response').that.deep.equals(res: 'data')
    expect(conveyor).to.have.property('data').that.deep.equals(prop: 'value')

  describe '#success()', ->

    it 'should correctly send success response', (done) ->

      # Fake response
      response = fake.Response()

      # Create a Conveyor and run some random stuff
      (conveyor = new Conveyor null, response, num: 0)
        .then input: 'num', (i) -> i + 1
        .then conveyor.success
        .promise
          .then ->
            # Here we observe results
            assert.isTrue(response.status.calledOnce)
            assert.isTrue(response.send.calledOnce)
            expect(response.statusCode).to.be.equal(200)
            expect(response.data).to.be.deep.equal(status: 200, result: 1)
            done()
          .catch (error) -> done(error)

    it 'should correctly detect config object', (done) ->
      # Fake response
      response = fake.Response()

      # Create a Conveyor and run some random stuff
      (conveyor = new Conveyor null, response, num: 0)
        .then input: 'num', (i) -> i + 1
        .then
          status: 201,
          conveyor.success
        .promise
          .then ->
            # Here we observe results
            assert.isTrue(response.status.calledOnce)
            assert.isTrue(response.status.calledWith 201)
            assert.isTrue(response.send.calledOnce)
            expect(response.send.firstCall.args[0]).to.be.deep.equal(
              status: 201,
              result: 1
            )
            done()
          .catch (error) -> done(error)

  describe '#error()', ->

    it 'should correctly send error response', (done) ->
      # Fake request & response
      request = fake.Request()
      response = fake.Response()

      # Create a Conveyor and run some random stuff
      (conveyor = new Conveyor request, response, num: 0)
        .then input: 'num', (i) -> i + 1
        .then -> @conveyor.panic('An error occured!', 501)
        .then -> done(new Error('Conveyor did not terminate on error!'))
        .catch conveyor.error
        .promise
          .then ->
            # Here we observe results
            assert.isTrue(response.status.calledOnce)
            assert.isTrue(response.status.calledWith 501)
            assert.isTrue(response.send.calledOnce)
            expect(response.send.firstCall.args[0]).to.have.property('status').that.equals(501)
            expect(response.send.firstCall.args[0]).to.have.deep.property('error.time')
            expect(response.send.firstCall.args[0]).to.have.deep.property('error.message')
              .that.equals('An error occured!')
            done()

    it 'should correctly replace error if config object says so', (done) ->
      # Fake request & response
      request = fake.Request()
      response = fake.Response()

      # Create a Conveyor and run some random stuff
      (conveyor = new Conveyor request, response, num: 0)
        .then input: 'num', (i) -> i + 1
        .then -> @conveyor.panic('An error occured!', 501)
        .then -> done(new Error('Conveyor did not terminate on error!'))
        .catch
          status: 999,
          message: 'We ran out of coffee!',
          conveyor.error
        .promise
          .then ->
            # Here we observe results
            assert.isTrue(response.status.calledOnce)
            assert.isTrue(response.status.calledWith 999)
            assert.isTrue(response.send.calledOnce)
            expect(response.send.firstCall.args[0]).to.have.property('status').that.equals(999)
            expect(response.send.firstCall.args[0]).to.have.deep.property('error.time')
            expect(response.send.firstCall.args[0]).to.have.deep.property('error.message')
              .that.equals('We ran out of coffee!')
            done()

describe 'ChasConveyor.ServerError', ->

  it '#constructor() should correctly assign parameters', ->

    error = new Conveyor.ServerError(fake.Request(), 999, 'Coffee!', prop: 'value')

    expect(error).to.have.property('time').that.is.instanceof(Date)
    expect(error).to.have.property('status').that.equals(999)
    expect(error).to.have.property('ip').that.equals('255.255.255.255')
    expect(error).to.have.property('method').that.equals('BREW')
    expect(error).to.have.property('url').that.equals('/brew/coffee?sugar=true')

  it '#toString() should return a correct string representation', ->

    error = new Conveyor.ServerError(fake.Request(), 999, 'Coffee!', prop: 'value')

    expect(error.toString())
      .to.contain('(255.255.255.255 -> BREW /brew/coffee?sugar=true)')

  describe '#convert()', ->

    it 'should correctly convert String to ServerError', ->

      error = Conveyor.ServerError.convert(fake.Request(), 'Coffee!')

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message').that.equals('Coffee!')

    it 'should correctly convert message/status pair to ServerError', ->

      error = Conveyor.ServerError.convert(fake.Request(), status: 999, message: 'Coffee!')

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(999)
      expect(error).to.have.property('message').that.equals('Coffee!')

    it 'should correctly convert SQLite errors to ServerError', ->

      sqlite_error =
        errno: 999
        code: 'ERROR_CODE'
        toString: -> 'SQLite Error!'
      error = Conveyor.ServerError.convert(fake.Request(), sqlite_error)

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message')
        .that.equals('Database access failed. (SQLite Error!)')

    it 'should not do anything with a ServerError object', ->

      srv_error = new Conveyor.ServerError(fake.Request(), 999, 'Coffee!')
      error = Conveyor.ServerError.convert(fake.Request(), srv_error)

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.be.deep.equal(srv_error)

    it 'should correctly handle unexpected node Error objects', ->
      node_err = new Error('Coffee!')
      error = Conveyor.ServerError.convert(fake.Request(), node_err)

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message')
        .that.equals('Unexpected error. (Error: Coffee!)')
      expect(error).to.have.property('details').that.deep.equals(node_err)

    it 'should correctly handle unexpected error objects', ->

      error = Conveyor.ServerError.convert(fake.Request(), prop: 'value')

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message')
        .that.equals('Unexpected error.')
      expect(error).to.have.property('details').that.deep.equals(prop: 'value')

    it 'should not crash when error object is null', ->
      error = Conveyor.ServerError.convert(fake.Request(), null)

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message')
        .that.equals('Error not specified.')
      expect(error.details).to.be.null

    it 'should not crash when error object is undefined', ->
      error = Conveyor.ServerError.convert(fake.Request())

      expect(error).to.be.an.instanceof(Conveyor.ServerError)
      expect(error).to.have.property('status').that.equals(500)
      expect(error).to.have.property('message')
        .that.equals('Error not specified.')
      expect(error.details).to.be.undefined
