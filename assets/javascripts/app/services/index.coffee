angular = require 'angular'

console.debug 'Registering Services...'

module = angular.module 'prostack.services', []

class MessageService

  constructor: ->
    console.debug "Intialized MessageService"

  getMessage: -> "Hello from MessageService!"

module.service 'messageService', MessageService
