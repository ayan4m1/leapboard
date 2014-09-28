module = angular.module 'leapboard.directive', [
  'leapboard.config'
  'leapboard.service'
]

module.directive 'reddit', ->
  restrict: 'E'
  scope:
    links: '='
  templateUrl: 'partials/reddit.html'

module.directive 'weather', ['weather', 'moment', (weather, moment) ->
  restrict: 'E'
  scope:
    observation: '='
  templateUrl: 'partials/weather.html'
  link: (scope, elem) ->
    scope.lastUpdated = 0
    scope.units =
      # todo: pressure units
      temp: switch weather.units
        when 'imperial' then 'F'
        when 'metric' then 'C'
        else 'K'
      wind: if weather.units is 'imperial' then 'mph' else 'm/s'

    # magic numbers from http://openweathermap.org/weather-conditions
    getIcon = (observation) ->
      weather = observation.weather

      hasCondition = (condition) -> weather.filter((v) -> v.id is condition).length > 0
      isDay = -> observation.sys.sunrise < observation.dt < observation.sys.sunset

      # cannot determine state
      return 'wi-alien' unless weather.length > 0

      # existence of extreme condition takes precedence
      icon = switch
        when hasCondition(781) or hasCondition(900) then 'wi-tornado'
        when hasCondition(903) or hasCondition(962) then 'wi-hurricane'
        when hasCondition(906) then 'wi-hail'
        else null
      return icon if icon?

      # todo: wind speed?
      # next find any non-clear states we have icons for
      condition = weather[0]
      icon = switch
        when 200 <= condition.id <= 232 then 'wi-thunderstorm'
        when 300 <= condition.id <= 321 then 'wi-sprinkle'
        when 500 <= condition.id <= 531 then 'wi-rain'
        when 600 <= condition.id <= 602 then 'wi-snow'
        when 611 <= condition.id <= 622 then 'wi-rain-mix'
        when 800 < condition.id <= 804 then 'wi-cloudy'
        else null
      return icon if icon?

      # if state is clear then determine day/night
      if hasCondition(800)
        return if isDay() then 'wi-day-sunny' else 'wi-night-clear'

      # cannot determine state
      return 'wi-alien'

    scope.$watch('observation', (v) ->
      return unless v?
      elem.find('.condition-icon').addClass(getIcon(v))
      scope.lastUpdated = moment()
      scope.currentConditions = weather.map((v) -> v.description).join(', ')
    )
]