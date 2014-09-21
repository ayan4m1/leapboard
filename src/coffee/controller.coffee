module = angular.module 'leapboard.controller', ['leapboard.service']

module.controller 'HomeController', ['$scope', 'input', ($scope, inputProvider) ->
  $scope.title = 'Home'
  $scope.gestures = []

  inputProvider.onSwipe = (direction) ->
    $scope.gestures.push(
      'direction': direction
    )
    $scope.$apply()

  inputProvider.connect()
]