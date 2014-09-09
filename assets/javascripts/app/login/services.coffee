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
    if @profile? then callback?.call null, @profile
    # Attempt to retrieve the current user from the localStorage.
    else
      @authClient.$getCurrentUser().then( (user)->
        if user?
          me._setCurrentUser(user)
          callback?.call null, user
        else
          callback?.call null, null
      )

  _registerProfileInfo: (user, profile, ref) =>
    profileInfo =
      id: user.uid
      provider: user.provider
      provider_link: ''
      displayName: user.displayName
      firstname: ''
      lastname: ''
      location: ''
      title: ''
      company: ''
      bio: ''
      image: ''
      twitter: ''
      blog: ''
      website: ''
      email: ''
      consults: @$firebase(ref.child('consults')).$asArray()
      mentors: @$firebase(ref.child('mentors')).$asArray()
      interests: @$firebase(ref.child('interests')).$asArray()
      presentations: @$firebase(ref.child('presentations')).$asArray()
      created: new Date().getTime()
    angular.extend profile, profileInfo

  _extractFirstAndLastName: (name) ->
    firstname = name
    lastname = name
    nameParts = name.trim().split(/\s+/);
    if nameParts.length == 2
      [ firstname, lastname ] = nameParts
    else if nameParts.length > 2
      firstname = nameParts[0]
      lastname = nameParts.slice(1).join(' ')
    [firstname, lastname]

  _userDataFromGithub: (userData, profile) ->
    profile.provider_link = userData.html_url
    [ profile.firstname,  profile.lastname ] = @_extractFirstAndLastName userData.name
    profile.image = userData.avatar_url ? ''
    profile.location = userData.location ? ''
    profile.company = userData.company ? ''
    profile.bio = userData.bio ? ''
    profile.blog = userData.blog ? ''
    profile.website = userData.blog ? ''
    profile.email = userData.email ? userData.emails?[0]?.email

  _userDataFromGoogle: (userData, profile) ->
    profile.provider_link = userData.link ? ''
    profile.image = userData.picture ? ''
    profile.email = userData.email ? ''
    profile.firstname = userData.given_name ? ''
    profile.lastname = userData.family_name ? ''

  _userDataFromFacebook: (userData, profile) ->
    profile.provider_link = userData.link ? ''
    profile.image = userData.picture?.data?.url ? ''
    profile.firstname = userData.first_name ? ''
    profile.lastname = userData.last_name ? ''

  _userDataFromTwitter: (userData, profile) ->
    profile.provider_link = "https://twitter.com/#{userData.screen_name}"
    [ profile.firstname,  profile.lastname ] = @_extractFirstAndLastName userData.name
    profile.image = userData.profile_image_url_https ? ''
    profile.location = userData.location ? ''
    profile.bio = userData.description ? ''
    profile.website = userData.url ? ''

  _setCurrentUser: (user) =>
    # Create a reference to the profile
    @profileRef = @ref.child "profiles/#{user.uid}"
    # Wrap the profile with the Angular Fire API.
    @sync = @$firebase @profileRef
    # Synchronize reference to the user's profile.
    @profile = @sync.$asObject()
    # When the profile is loaded, look to see
    # if the user has already been registered.
    # If not, take properties from the user object
    # do a best first pass on the profile.
    @profile.$loaded().then =>
      unless @profile.created?
        console.log "First time profile has been created"
        # Set the global properties from the Firebase User object.
        @_registerProfileInfo user, @profile, @profileRef
        # For each provider, normalize the profile data.
        switch user.provider
          when 'github' then userData = @_userDataFromGithub user.thirdPartyUserData, @profile
          when 'facebook' then userData = @_userDataFromFacebook user.thirdPartyUserData, @profile
          when 'google' then userData = @_userDataFromGoogle user.thirdPartyUserData, @profile
          when 'twitter' then userData = @_userDataFromTwitter user.thirdPartyUserData, @profile
          else console.error "Unknown login provider '#{user.provider}'."
        # Save the record
        @profile.$save()
      # Notify listeners
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
