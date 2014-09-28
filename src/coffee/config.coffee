module = angular.module 'leapboard.config', []

module.constant 'updateInterval': 120 # in seconds
module.constant 'weather',
  baseUri: 'http://api.openweathermap.org/data/2.5/weather'
  location: 'New York, NY'
  units: 'imperial' # can be 'default', 'imperial', or 'metric'