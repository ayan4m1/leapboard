module = angular.module 'leapboard.config', []

module.constant 'updateInterval', ['moment', (moment) ->
  moment.duration(120, 'seconds').as('milliseconds')
]

module.constant 'weather',
  baseUri: 'http://api.openweathermap.org/data/2.5/weather'
  units: 'imperial' # can be 'default', 'imperial', or 'metric'
  location: 'New York, NY'