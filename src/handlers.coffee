debug = (require 'debug')((require '../package').name)
webhookHandler = require './webhook'

module.exports = (params) ->
  'NotFound': noop
  'mt.supportedMethods': handleResponse ['metaWeblog.getRecentPosts', 'metaWeblog.newPost']
  'wp.newCategory': handleResponse {}
  'metaWeblog.getCategories': handleResponse []
  'metaWeblog.getRecentPosts': handleResponse []
  'metaWeblog.newPost': webhookHandler(params)

noop = ->
  debug "XMLRPC noop invoked", arguments

handleResponse = (value) ->
  (err, args, cb) ->
    debug "XMLRPC server responding:", args, value
    cb null, value
