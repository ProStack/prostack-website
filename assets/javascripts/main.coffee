# Gross jQuery and plugins that will bind to Window.
require 'jquery'
require 'jqnicescroll'
require 'jqeasing'
require 'cbpAnimatedHeader'
require 'jqparallax'
# Application dependencies
require 'bootstrap'
angular = require 'angular'
require 'uirouter'
require 'uibootstrap'
require './app/services'
require './app/directives'
require './app/login'

# Instantiate the application.
app = angular.module 'prostack', [
  'ui.router',
  'ui.bootstrap',
  'prostack.services',
  'prostack.directives',
  'prostack.login'
]

# Mimosa compile templates will be pulled from the 'templates'
# file and registered with Angular's template cache.
# This will circumvent Angular from making GET calls to the
# server.
app.run [ '$templateCache', ($templateCache) ->
  templates = require 'templates'
  for name, template of templates
    # If you're having trouble determining whether your template is loaded,
    # uncomment this guy.
    #console.debug "Registering '#{name}' with $templateCache."
    $templateCache.put "#{name}.html", template
]

app.config [ '$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->

    $urlRouterProvider.otherwise "/"

    $stateProvider
      .state 'home', {
        url: '/'
        templateUrl: 'pages-home.html'
        controller: 'HomeCtrl'
      }
      # .state 'view1', {
      #   url: '/view1'
      #   templateUrl: 'view1.html'
      #   controller: 'View1Ctrl'
      #   resolve:
      #     message: (messageService) ->
      #       return messageService.getMessage()
      # }
      # .state 'view2', {
      #   url: '/view2'
      #   templateUrl: 'view2.html'
      #   controller: 'View2Ctrl'
      #   resolve:
      #     message: ($http) ->
      #       $http.get('/message').then (response) ->
      #         response.data.message
      # }
]

#  Immutable storage for configuration.  Later implementations may use an
#  AJAX request to load options from the server.
class ConfigService

  constructor: ->
    @config = require './config'

  getItem: (item) => @config[item]


app.factory 'configService', -> new ConfigService()

# Home Controller
app.controller "HomeCtrl", [ '$scope', ($scope) ->

]
#
# app.controller "View2Ctrl", [ '$scope', 'message', ($scope, message) ->
#   $scope.message = message
# ]
