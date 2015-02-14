# --------------------------------------------------------------------------- #
#                                                                             #
# ChasConveyor utility plugins that do all kinds of stuff.                    #
#                                                                             #
# --------------------------------------------------------------------------- #
_        = require('underscore')
schema   = require('js-schema')

# Export util object
util = module.exports

# --------------------------------------------------------------------------- #
# Verifies {data} against a schema and outputs the data if valid.             #
# --------------------------------------------------------------------------- #
util.schema = (data) ->
  if not schema(@config.schema)(data)
    @conveyor.panic(@config.message ? 'Invalid arguments.', @config.status ? 400)
  return data

# --------------------------------------------------------------------------- #
# Checks if {data} exists. In other words, it is not null or undefined.       #
# Note that falsy values such as 0 or false are considered to exist.          #
# --------------------------------------------------------------------------- #
util.exists = (data) ->
  if _.isNull(data) or _.isUndefined(data)
    @conveyor.panic(
      @config.message ? 'Null or undefined value detected.',
      @config.status ? 400
    )
  return data
