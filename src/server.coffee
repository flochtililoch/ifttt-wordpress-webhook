{assign} = require 'lodash'
xmlrpc = require 'xmlrpc'
debug = (require 'debug')((require '../package').name)
config = require './config'
handlers = require './handlers'

module.exports = (params = {}) ->
  serverConfig = assign(config.server, params.server)
  debug 'Initializing XMLRPC server with following config:', serverConfig
  server = xmlrpc.createServer(serverConfig)

  methodsHandlers = assign(handlers(params), params.handlers)
  for method, handler of methodsHandlers
    debug "Binding following handler to XMLRPC server method `#{method}`:", handler
    server.on(method, handler)

  server
