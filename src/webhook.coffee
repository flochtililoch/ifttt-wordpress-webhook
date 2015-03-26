debug = (require 'debug')((require '../package').name)

module.exports = (params = {}) ->
  {user, webhook} = params

  throw new Error('user.name and user.password are mandatory parameters') unless user.name? and user.password?
  throw new Error('webhook parameter should be defined as a function') unless typeof webhook is 'function'

  (err, args, cb) ->

    debug 'Pre-Webhook invoked by IFTTT with following arguments', args

    # First param is not used
    args.shift()

    [username, password, body] = args

    throw new Error('incorrect username / password combination', args) unless username is user.name and password is user.password

    # Immediately send response to IFTTT
    cb(null, 0)

    # Invoke webhook
    debug 'Invoking webhook with following arguments', body
    webhook(body)
