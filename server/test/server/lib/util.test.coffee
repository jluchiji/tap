chai = require('chai')
sinon = require('sinon')
assert = chai.assert
should = chai.should()
expect = chai.expect

# Load fixtures and tested class
fake = require('../../fake/conveyor.coffee')
util = require('../../../dist/lib/util.js')

describe 'util', ->

  describe '#schema()', ->

    it 'should check object against a js-schema', ->
      schema =
        a: String
        b: Number

      result = fake.ConveyorRun(schema: schema, util.schema)(a: 'prop', b: 0)
      expect(result).to.be.deep.equal(a: 'prop', b: 0)

      fn = -> fake.ConveyorRun(schema: schema, util.schema)(a: 0, b: 'prop')
      expect(fn).to.throw(Error, '400|Invalid arguments.')

    it 'should not crash when checking a null or undefined value', ->
      schema =
        a: String
        b: Number

      fn = -> fake.ConveyorRun(schema: schema, util.schema)(null)
      expect(fn).to.throw(Error, '400|Invalid arguments.')

      fn = -> fake.ConveyorRun(schema: schema, util.schema)()
      expect(fn).to.throw(Error, '400|Invalid arguments.')

    it 'should correctly replace error info if configured so', ->
      schema =
        a: String
        b: Number

      config = schema: schema, status: 999, message: 'Coffee!'
      fn = -> fake.ConveyorRun(config, util.schema)(a: 0, b: 1)
      expect(fn).to.throw(Error, '999|Coffee!')

  describe '#exists()', ->

    it 'should check that object is not null or undefined', ->

      result = fake.ConveyorRun(null, util.exists)(prop: 'value')
      expect(result).to.be.deep.equal(prop: 'value')

      fn = -> fake.ConveyorRun(null, util.exists)(null)
      expect(fn).to.throw(Error, '400|Null or undefined value detected.')

      fn = -> fake.ConveyorRun(null, util.exists)()
      expect(fn).to.throw(Error, '400|Null or undefined value detected.')

    it 'should not consider falsy values as non existing', ->

      result = fake.ConveyorRun(null, util.exists)(no)
      expect(result).to.be.equal(no)

      result = fake.ConveyorRun(null, util.exists)(0)
      expect(result).to.be.equal(0)

      result = fake.ConveyorRun(null, util.exists)('')
      expect(result).to.be.equal('')

      result = fake.ConveyorRun(null, util.exists)(NaN)
      expect(result).to.be.deep.equal(NaN)

    it 'should correctly replace error info if configured so', ->

      config = status: 999, message: 'Coffee!'
      fn = -> fake.ConveyorRun(config, util.exists)(null)
      expect(fn).to.throw(Error, '999|Coffee!')
