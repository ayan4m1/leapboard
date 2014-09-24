module = angular.module 'leapboard.directive', []

module.directive 'reddit', ->
  restrict: 'E'
  scope:
    links: '='
  templateUrl: 'partials/reddit.html'

module.directive 'weather', ->
  restrict: 'E'
  scope:
    observation: '='
  templateUrl: 'partials/weather.html'