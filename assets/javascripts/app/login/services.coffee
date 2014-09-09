angular = require 'angular'
require 'firebase'

class LoginService

  constructor: (@$firebase, @$firebaseSimpleLogin, @configService, @$rootScope) ->
    @ref = new Firebase(@configService.getItem('firebase.url'))
    @authClient = @$firebaseSimpleLogin(@ref)

  login: (provider) =>
    me = @
    @auth = @authClient.$login(provider)
      .then((user) -> me._setCurrentUser(user))

  logout: =>
    @authClient.$logout()
    @profile = null
    @_notifyListeners()

  getCurrentUser: (callback) =>
    me = @
    # Return the current user if we already have it cached.
    if @profile?
      callback?.call null, @profile
    # Attempt to retrieve the current user from the localStorage.
    else
      @authClient.$getCurrentUser().then( (user)->
        if user?
          me._setCurrentUser(user)
          callback?.call null, user
        else
          callback?.call null, null
      )

  _userDataFromGithub = (user) =>
    {}

  _userDataFromGoogle = (user) =>
    {}

  _userDataFromFacebook = (user) =>
    {}

  _userDataFromTwitter = (user) =>
    {}

  _setCurrentUser: (user) =>
    console.log user
    @profileRef = @ref.child("profiles/#{user.uid}")
    @sync = @$firebase(@profileRef)
    @profile = @sync.$asObject()
    @profile.$loaded().then =>
      console.log "Loaded"
      console.log arguments
      unless @profile.created?
        console.log "First time profile has been created"
        userData = null
        switch user.provider
          when 'github' then userData = _userDataFromGithub(user)
          when 'facebook' then userData = _userDataFromGoogle(user)
          when 'google' then userData = _userDataFromFacebook(user)
          when 'twitter' then userData = _userDataFromTwitter(user)
          else console.error "Unknown login provider '#{user.provider}'."
        angular.extend @profile, userData
        @profile.created = new Date().getTime()
        @profile.$save()
      @_notifyListeners()


  _notifyListeners: =>
    @$rootScope.$broadcast 'loginStatusChanged', @profile

exports.register = (loginModule) ->
  loginModule.service 'loginService', [
    '$firebase',
    '$firebaseSimpleLogin',
    'configService',
    '$rootScope',
    ($firebase, $firebaseSimpleLogin, configService, $rootScope) ->
      new LoginService($firebase, $firebaseSimpleLogin, configService, $rootScope)
  ]
