# --------------------------------------------------------------------------- #
#                                                                             #
# Cryptographic utilities (Mostly Q.js wrappers)                              #
#                                                                             #
# --------------------------------------------------------------------------- #
_       = require('underscore')
bcrypt  = require('bcrypt-nodejs')
crypto  = require('crypto')
Promise = require('bluebird')
msgpack = require('msgpack')
urlsafe = require('urlsafe-base64')
winston = require('winston')


config  = require('../config/auth-policy.json')

self = module.exports

# ------------------------------------------------------------------------- #
# Generates salt for bcrypt password hashing                                #
# ------------------------------------------------------------------------- #
self.genSalt = Promise.promisify bcrypt.genSalt

# ------------------------------------------------------------------------- #
# Hashes the data using bcrypt                                              #
# ------------------------------------------------------------------------- #
self.hash = Promise.promisify bcrypt.hash

# ------------------------------------------------------------------------- #
# Compares hashed data with a pre-existing hash                             #
# ------------------------------------------------------------------------- #
self.compare = (plain, hash) ->
  return new Promise (resolve, reject) ->
    bcrypt.compare plain, hash, (error, result) ->
      if error then reject(error)
      else resolve(result)

# ------------------------------------------------------------------------- #
# Generates a bcrypt hash of the password                                   #
# ------------------------------------------------------------------------- #
self.bcryptHash = (password) ->
  return new Promise (resolve, reject) ->
    bcrypt.genSalt config.salt_rounds, (error, result) ->
      if error then reject(error)
      else bcrypt.hash password, result, null, (error, result) ->
        if error then reject(error)
        else resolve(result)

# ------------------------------------------------------------------------- #
# Generates crypto. strong array of random bytes encoded in base64          #
# ------------------------------------------------------------------------- #
self.generateAuth = ->
  Promise.promisify(crypto.randomBytes)(config.auth_size)
    .then (buf) -> buf.toString('base64')

# ------------------------------------------------------------------------- #
# Generates a keyed hash of data in base64 format                           #
# ------------------------------------------------------------------------- #
self.hmacDigest = (data, key, short = yes, algorithm = 'SHA256') ->
  return new Promise (resolve) ->
    hash = crypto.createHmac(algorithm, key).update(data).digest()
    # With `short` set to true, discard right half of the hash output
    if short then hash = hash.slice(0, hash.length / 2)
    # Resolve with hash
    resolve hash.toString('base64')

# ------------------------------------------------------------------------- #
# Generates an authorization token for the specified user.                  #
#                                                                           #
# user   : User object as returned from database model.                     #
# secure : If true, forces revocation of all previous tokens on use.        #
# ------------------------------------------------------------------------- #
self.createToken = (user, secure = no) ->
  # Get timestamp and create the token metadata object
  time = Math.floor(new Date().getTime() / 1000)
  meta = [ secure, user.id, time ]
  # Pack meta into payload
  payload = msgpack.pack(meta)
  # Calculate HMAC SHA-256 singature of the token
  self.hmacDigest(payload, user.auth)
    .then (hash) ->
      # Pack singature into the token meta as well
      meta.push(hash)
      # Output the resulting token
      urlsafe.encode(msgpack.pack meta)
