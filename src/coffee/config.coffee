module = angular.module 'leapboard.config', []

module.constant 'weather',
  baseUri: 'http://api.wunderground.com/api'
  apiKey: 'invalidkey' # obtain at http://www.wunderground.com/weather/api/
  zip: 12345