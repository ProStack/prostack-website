angular = require 'angular'
require 'firebase'
require 'firebasesl'
require 'angularfire'

loginModule = angular.module('prostack.login', ['firebase'])

(require './services').register(loginModule)
(require './controllers').register(loginModule)
