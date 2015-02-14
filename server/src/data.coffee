# --------------------------------------------------------------------------- #
#                                                                             #
# Special file for the global database object.                                #
#                                                                             #
# --------------------------------------------------------------------------- #
_       = require('underscore')
fs      = require('fs')
squel   = require('squel')
sqlite  = require('q-sqlite3')
winston = require('winston')

self = module.exports

# --------------------------------------------------------------------------- #
# Create database connection and initialize as needed.                        #
# --------------------------------------------------------------------------- #
self.create = (dbFile, initFile) ->
  # Create database
  sqlite.createDatabase(dbFile)

  # Configure SQLite to enable optional functionality
  .then (db) ->
    winston.info 'SQLite database connected.'
    db.exec 'PRAGMA foreign_keys=ON;'

  # Assign to global database object
  .then (db) ->
    winston.info 'Turned on foreign key support.'
    self._database = db
    db.get('SELECT COUNT(*) AS count FROM sqlite_master')

  # Detect empty database and
  .then (result) ->
    if result.count is 0
      winston.info 'Empty database detected...initializing'
      return self._database.exec fs.readFileSync(initFile, 'utf8')

  # Monkey-patch database to run squel queries directly
  .then -> self.patchSquel(self._database)

# --------------------------------------------------------------------------- #
# Monkey-patcher that adds compatibility for squel.js queries.                #
# --------------------------------------------------------------------------- #
self.patchSquel = (db) ->
  patch = (db, fnName) ->
    # No patch for undefined db
    if not db then return
    # Check if this function is valid
    if not _.isFunction(db[fnName])
      throw new Error('Cannot monkey patch non-function property: ' + fnName)
    # Backup the old method
    db[old = '__' + fnName] = db[fnName]
    # Set up the new method
    db[fnName] = (query) ->
      if query instanceof squel.cls.QueryBuilder
        query = query.toParam()
        return @[old](query.text, query.values)
      else
        return @[old].apply(@, arguments)
  patch(db, 'run')
  patch(db, 'get')
  patch(db, 'all')
  patch(db, 'exec')
  patch(db, 'prepare')
  return db
