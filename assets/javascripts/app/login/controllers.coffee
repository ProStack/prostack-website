
# Handles login.
LoginCtrl = ['$scope', '$modal', 'loginService', ($scope, $modal, loginService) ->

  providers = ['twitter', 'google', 'facebook', 'github']

  loginService.getCurrentUser (profile) ->
    $scope.profile = profile

  $scope.$on 'loginStatusChanged', (e, profile) ->
    $scope.profile = profile

  $scope.showLoginOptions = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'select-login.html',
      controller: 'SelectAuthProviderCtrl',
      size: size,
      resolve: {
        providers: ->
          return providers;
        }
    )

    success = (provider) -> loginService.login(provider)
    cancel = ->  console.log('Modal dismissed at: ' + new Date())

    # Pop the modal.
    modalInstance.result.then(success, cancel)

  $scope.showProfileOptions = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'profile-options.html',
      controller: 'SelectProfileActionsCtrl',
      size: size,
      resolve: {
        profile: ->
          return $scope.profile
      }
    )
    success = (action) ->
      console.log "ACTION SELECTED: #{action}"
      if action is 'logout'
        loginService.logout()
      else if action is 'edit'
        console.log 'Edit profile'
    cancel = ->  console.log('Modal dismissed at: ' + new Date())

    # Pop the modal.
    modalInstance.result.then(success, cancel)

  $scope.logout = ->
    loginService.logout()
]

# Allows users to select their desired authentication provider.
SelectAuthProviderCtrl = [ '$scope', '$modalInstance', 'providers', ($scope, $modalInstance, providers) ->

  $scope.providers = providers

  $scope.select = (provider) ->
    $modalInstance.close(provider)

  $scope.cancel = -> $modalInstance.dismiss('cancel')
]


# Handles actions related to the user profile.
SelectProfileActionsCtrl = [ '$scope', '$modalInstance', 'profile', ($scope, $modalInstance, profile) ->

  $scope.profile = profile

  $scope.editProfile = ->
    $modalInstance.close('edit')

  $scope.logout = ->
    $modalInstance.close('logout')

  $scope.cancel = -> $modalInstance.dismiss('cancel')
]

# Export the controllers.  We will use a register function to allow use to bind onto
# the supplied Angular module.
exports.register = (module) ->
  module.controller 'LoginCtrl', LoginCtrl
  module.controller 'SelectAuthProviderCtrl', SelectAuthProviderCtrl
  module.controller 'SelectProfileActionsCtrl', SelectProfileActionsCtrl
