module = angular.module 'leapboard.controller', ['leapboard.service']

class Widget
  constructor: (@name, @title) ->
  selected: false
  update: ->

module.controller 'HomeController', ['$scope', '$http', 'input', ($scope, $http, inputProvider) ->
  class RedditWidget extends Widget
    constructor: -> super 'reddit', 'Reddit'
    update: ->
      $http(
        method: 'GET'
        url: 'http://www.reddit.com/.json'
      ).success (data) =>
        @links = data.data.children.map (v) ->
          href: v.data.url
          title: v.data.title

  class TextWidget extends Widget
    constructor: -> super 'text', 'Text'
    update: ->
      @text = 'Umm this.'

  $('#widget-carousel').carousel(
    interval: false
  )
  $scope.title = 'Home'
  $scope.widgets = [
    new RedditWidget()
    new TextWidget()
  ]
  $scope.select = (idx) ->
    console.log(idx)
    $scope.selected.selected = false if $scope.selected?
    $scope.selected = $scope.widgets[idx]
    $scope.selected.selected = true
    $scope.selected.update()
    $scope.$apply()


  inputProvider.onSwipe = (direction) ->
    idx = $scope.widgets.indexOf($scope.selected)

    if direction is 'left' then $('#widget-carousel').carousel('next')
    else if direction is 'right' then $('#widget-carousel').carousel('prev')

    idx = if idx < 0 then 0 else if idx >= $scope.widgets.length then $scope.widgets.length - 1 else idx
    $scope.select(idx)

  inputProvider.connect()
]