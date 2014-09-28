module = angular.module('leapboard.filter', ['leapboard.service'])

module.filter 'formatDate', ['moment', (moment) ->
  (value, format) ->
    format = 'MM/dd/yyyy' unless format?
    return '' unless value?
    return 'never' if value is 0
    return moment(value).format(format)
]