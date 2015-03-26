# ifttt-wordpress-webhook

IFTTT Wordpress Webhook is a tiny package that allows a node application to expose a webhook, that can be triggered by IFTTT. It basically wraps a xmlrpc server with basic configuration, that mimics a typical wordpress server and run custom code when the method `newPost` is invoked by IFTTT.


## Getting started

- Configure IFTTT Wordpress Channel

![IFTTT Wordpress Channel configuration](https://github.com/flochtililoch/ifttt-wordpress-webhook/blob/assets/ifttt-wordpress-channel.png)

- Create a IFTTT receipe with Wordpress as an action ("then")

- Run the following code in a public facing machine

```javascript
var iftttWebHook = require('ifttt-wordpress-webhook');
iftttWebHook({user: {
    name: 'foo',
    password: 'bar'
  },
  webhook: function(data) {
    // Do something
  }
})
```



## Usage example: Proxy IFTTT action to another service

The idea here is to use some of the available fields in wordpress to define the service parameters.
Let's assume the following:

- The `Title` field will contain the method and the url
- The `Body` field will contain the body to send to the service
- The `Categories` field will contain the headers name
- The `Tags` field will contain the headers values

### Create the following receipe in IFTTT

*Note:* The service url does not contain the protocol. The reason behind this is that IFTTT rewrites URLs contained in a receipe fields into a short url, i.e. `http://ift.tt/3NrWPwT`. To prevent that, the protocol is manually happended before invoking the webhook. Currently only supports `http`.

![IFTTT Wordpress Receipe for Webhook Proxy](https://github.com/flochtililoch/ifttt-wordpress-webhook/blob/assets/ifttt-wordpress-receipe.png)


### Run the following code in a public facing machine

```javascript
var request = require('request'),
    _ = require('lodash'),
    iftttWebHook = require('ifttt-wordpress-webhook');

/*
Example payload:
[ '',
'foo',
'bar',
{ title: 'PUT //my.server.com/my/endpoint',
description: '{"message":"test"}',
categories: [ 'X-Request-ID', 'User-Agent' ],
mt_keywords: [ '1234567890', 'ifttt-wordpress-webhook' ],
post_status: 'publish' },
true ]
*/
function webhook (data) {
  console.log ('webhook invoked with following data:', data);

  // Map fields
  var cache1 = data.title.split(' ');
  var options = {
    method: cache1[0],
    url: 'http:' + cache1[1], // See note above
    headers: _.zipObject(data.categories, data.mt_keywords),
    json: JSON.parse(data.description)
  };

  /* options equals to
  { method: 'PUT',
  url: 'http://my.server.com/my/endpoint',
  headers:
   { 'X-Request-ID': '1234567890',
     'User-Agent': 'ifttt-wordpress-webhook' },
  json: { message: 'Test' } }
  */
  request(options);
}

var params = {
  user: {
    name: 'foo',
    password: 'bar'
  },
  webhook: webhook
};

server = iftttWebHook(params);

```

## Options

### user
Type: `Object`

*Mandatory*. Need to match the user and password filled out in the Wordpress Channel in IFTTT.

### webhook
Type: `Function`

*Mandatory*. Function to invoke when the webhook is triggered.

### server
Type: `Object`
Default: `{host: 'localhost', path: '/xmlrpc.php', port: 80}`

Specify XMLRPC server configuration that IFTTT service hits.


## Build

```bash
$ npm run build
````
