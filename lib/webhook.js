// Generated by CoffeeScript 1.8.0
var debug;

debug = (require('debug'))((require('../package')).name);

module.exports = function(params) {
  var user, webhook;
  if (params == null) {
    params = {};
  }
  user = params.user, webhook = params.webhook;
  if (!((user.name != null) && (user.password != null))) {
    throw new Error('user.name and user.password are mandatory parameters');
  }
  if (typeof webhook !== 'function') {
    throw new Error('webhook parameter should be defined as a function');
  }
  return function(err, args, cb) {
    var body, password, username;
    debug('Pre-Webhook invoked by IFTTT with following arguments', args);
    args.shift();
    username = args[0], password = args[1], body = args[2];
    if (!(username === user.name && password === user.password)) {
      throw new Error('incorrect username / password combination', args);
    }
    cb(null, 0);
    debug('Invoking webhook with following arguments', body);
    return webhook(body);
  };
};
