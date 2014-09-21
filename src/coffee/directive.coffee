module = angular.module 'leapboard.directive', []

module.directive 'reddit', ->
  restrict: 'E'
  scope:
    links: '='
  templateUrl: 'partials/reddit.html'