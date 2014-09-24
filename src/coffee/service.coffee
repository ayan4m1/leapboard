module = angular.module 'leapboard.service', []

module.factory 'input', ['$window', ($window) ->
  swipeWatcher: null
  lastDirection: null
  controller: null
  onSwipe: null
  threshold: 10
  connect: ->
    @controller = new $window.Leap.Controller(
      enableGestures: true
    )
    @controller.connect()

    @swipeWatcher = @controller.gesture('swipe')
    @swipeWatcher.update((e) =>
      offset = e.translation()

      maxDir = Math.max(Math.abs(offset[0]), Math.abs(offset[1]), Math.abs(offset[2]))
      return unless maxDir > @threshold

      if maxDir is Math.abs(offset[0])
        direction = if offset[0] > 0 then 'left' else 'right'

      if maxDir is Math.abs(offset[1])
        direction = if offset[1] > 0 then 'down' else 'up'

      if maxDir is Math.abs(offset[2])
        direction = if offset[2] > 0 then 'in' else 'out'

      if direction isnt @lastDirection
        @lastDirection = direction
        @onSwipe(direction)
    )
]

module.factory 'redditWidget', ['$http', ($http) ->
  ->
    id: 'reddit'
    update: ->
      $http(
        method: 'GET'
        url: 'http://www.reddit.com/.json'
      ).success (data) =>
        @links = data.data.children.map (v) ->
          href: v.data.url
          title: v.data.title
          thumbnail: v.data.thumbnail
]

module.factory 'weatherWidget', ['$http', ($http) ->
  (apiKey) ->
    id: 'weather'
    baseUri: 'http://api.wunderground.com/api'
    'apiKey': apiKey
    update: ->
      $http.jsonp("#{@baseUri}/#{@apiKey}/conditions/q/CA/Mountain%20View.json?callback=JSON_CALLBACK")
      .success (data) =>
        @observation = data.current_observation
]