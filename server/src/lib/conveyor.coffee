# --------------------------------------------------------------------------- #
#                                                                             #
# Application-specific conveyor.                                              #
#                                                                             #
# --------------------------------------------------------------------------- #
_         = require('underscore')
chalk     = require('chalk')
moment    = require('moment')
winston   = require('winston')
Conveyor  = require('promise-conveyor')

# --------------------------------------------------------------------------- #
# Conveyor class specific for Chas server.                                    #
# --------------------------------------------------------------------------- #
class ChasConveyor extends Conveyor

  constructor: (@request, @response, data) ->
    super(data)

  panic: (message, status = 500, details) ->
    throw new ChasConveyor.ServerError(@request, status, message, details)

  success: (data) ->
    @conveyor.response
      .status @config?.status ? 200
      .send status: @config?.status ? 200, result: data

  error: (error) ->
    # Unify error format and log to winston
    error = ChasConveyor.ServerError.convert(@conveyor.request, error)
    winston.warn(error.toString())
    # Replace error information if needed
    if @config?.status then error.status = @config.status
    if @config?.message then error.message = @config.message
    # Prepare and send the response
    data =
      status: error.status
      error:
        time: moment().format('MMM-DD-YYYY hh:mm:ss.SSS A')
        message: error.message
    @conveyor.response.status(error.status).send(data)
    # If there is a next callback specified in config, call that one too
    if _.isFunction(@config.callback) then @config.callback(error)


# --------------------------------------------------------------------------- #
# ServerError object that contains information about request/response.        #
# --------------------------------------------------------------------------- #
class ChasConveyor.ServerError extends Conveyor.Error

  constructor: (request, status, message, details) ->
    @time = new Date()
    @status = status ? 500
    @ip = request.ip
    @method = request.method
    @url = request.originalUrl
    super(message, details)

  toString: ->
    time = moment().format('MMM-DD-YYYY hh:mm:ss.SSS A')
    return '[' + chalk.gray("#{time}") + "] " +
      chalk.cyan("(#{@ip} -> #{@method} #{@url}) ") +
      "message: #{@message}"

  @convert: (req, error) ->

    # Detect null/undefined req objects
    if not req
      throw new Error('Cannot convert errors without a request object!')

    # No error object supplied
    if not error
      return new ChasConveyor.ServerError(
        req, 500, 'Error not specified.', error)

    # Simple string describing the error
    if _.isString(error)
      return new ChasConveyor.ServerError(req, 500, error)

    # Message/Status bundles
    if error.message and error.status
      return new ChasConveyor.ServerError(req, error.status, error.message)

    # SQLite Errors (have errno and code defined)
    if error.errno and error.code
      return new ChasConveyor.ServerError(
        req, 500, 'Database access failed.', error)

    # ChasConveyor.ServerError instances returned as is
    if error instanceof ChasConveyor.ServerError then return error

    # Unexpected errors
    if _.isObject(error)
      return new ChasConveyor.ServerError(req, 500, 'Unexpected error.', error)

# --------------------------------------------------------------------------- #
# AuthError object represents rejected credentials.                           #
# --------------------------------------------------------------------------- #
class ChasConveyor.AuthError extends ChasConveyor.ServerError

  constructor: (request, status, message, details) ->
    super(request, status, message, details)

# Export the conveyor
module.exports = ChasConveyor
