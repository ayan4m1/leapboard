module = angular.module 'leapboard.controller', ['leapboard.service']

module.controller 'HomeController', ['$scope', '$http', 'input', 'redditWidget', 'weatherWidget', ($scope, $http, inputProvider, redditWidget, weatherWidget) ->
  $('#widget-carousel').carousel(
    interval: false
  )
  $scope.title = 'Home'
  $scope.widgets = [
    redditWidget()
    weatherWidget('changeme') # todo: make this configurable
  ]
  $scope.select = (idx) ->
    $scope.selected?.selected = false
    $scope.selected = $scope.widgets[idx]
    $scope.selected.selected = true
    $scope.selected.update()

  inputProvider.onSwipe = (direction) ->
    idx = $scope.widgets.indexOf($scope.selected)

    if direction is 'left'
      idx--
      $('#widget-carousel').carousel('next')
    else if direction is 'right'
      idx++
      $('#widget-carousel').carousel('prev')

    idx = if idx < 0 then 0 else if idx >= $scope.widgets.length then $scope.widgets.length - 1 else idx
    $scope.select(idx)

  inputProvider.connect()
  $scope.select(0)
]