module = angular.module 'leapboard.service', ['leapboard.config']

module.factory 'moment', ['$window', ($window) ->
  $window.moment
]

module.factory 'input', ['$window', ($window) ->
  swipeWatcher: null
  lastDirection: null
  controller: null
  onSwipe: null
  threshold: 10
  connect: ->
    @controller = new $window.Leap.Controller(
      host: '172.27.127.113'
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

module.factory 'weatherWidget', ['$http', 'weather', 'moment', ($http, weather, moment) ->
  ->
    id: 'weather'
    lastUpdate: 0
    update: ->
      return unless moment().diff(@lastUpdate, 'seconds') > weather.updateInterval
      $http.jsonp("#{weather.baseUri}/?q=#{weather.location}&callback=JSON_CALLBACK")
      .success (data) =>
        @lastUpdate = moment()
        @observation = data
]