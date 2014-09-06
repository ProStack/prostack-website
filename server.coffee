Hapi = require 'hapi'
fs   = require 'fs'

exports.startServer = (config, callback) ->

  port = config?.server?.port or 3000

  server = new Hapi.Server 'localhost', port

  # Default Route (serve index.html)
  server.route {
      method: 'GET'
      path: '/'
      handler: (req, reply) ->
        reply.file 'public/index.html'
  }

  # Statically load public assets.
  server.route {
      method: 'GET'
      path: '/{param*}'
      handler:
        directory:
          path: 'public'
          listing: true
  }

  server.start ->
    console.log 'Server running at:', server.info.uri

  callback server.listener
