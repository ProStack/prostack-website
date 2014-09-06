angular = require 'angular'

console.debug 'Registering Directives...'

module = angular.module 'prostack.directives', []

module.directive 'fa', [ ->
  restrict: 'E'
  transclude: true
  scope: true
  template: '<i class="fa" ng-class="clazz"></i>'
  link: (scope, element, attrs) ->
    scope.clazz = attrs.ico ? 'fa-question'
]

require 'gmap3'

parseLatLon = (latLonStr) ->
  [lat, lon] = latLonStr.split(",")
  [ parseFloat(lat), parseFloat(lon) ]

module.directive 'map', [ ->
  template: '<div class="gmap"></div>'
  restrict: 'E'
  link: (scope, element, attrs) ->

    center = [ 33.148172, -117.218047 ]
    if attrs.center?
      center = parseLatLon attrs.center

    marker = [ 33.148172, -117.218047 ]
    if attrs.marker?
      marker = parseLatLon attrs.marker

    zoom = 12
    if attrs.zoom?
      zoom = parseInt(attrs.zoom)

    iconImg = "https://dl.dropboxusercontent.com/u/29545616/Preview/location.png"

    $("div", element[0]).gmap3 {
      map:
        options:
          center: center
          zoom: zoom
          scrollwheel: false
      marker:
        latLng: marker
        options:
          icon: new google.maps.MarkerImage(iconImg, new google.maps.Size(48, 48, "px", "px"))
    }
]
