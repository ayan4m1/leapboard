module = angular.module 'leapboard.config', []

module.constant 'weather',
  baseUri: 'http://api.openweathermap.org/data/2.5/weather'
  updateInterval: 120
  location: 'New York, NY'

