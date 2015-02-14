path = require('path')
sqlite  = require('q-sqlite3')
chai = require('chai')
sinon = require('sinon')
Promise = require('bluebird')
winston = require('winston')
assert = chai.assert
should = chai.should()
expect = chai.expect

# Disable winston logging for this file
winston.info = sinon.spy()

# Fake request object with mockup data
fake = module.exports

# Load init script for the fake data
init = path.join __dirname, 'test-data.sql'

# Load real data module
data = require('../../dist/data.js')

# Close the old database if necessary...
fake.reset = -> data.create(':memory:', init)
