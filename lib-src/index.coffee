_ = require 'lodash'
smal = require 'smal'

String::trimRight ?= -> @replace /\s+$/, ''

h = htmlEscape = do ->
  # Based on https://github.com/wycats/handlebars.js/blob/49fcf10de21b89c504d641e72ce6c31c2feaed8f/lib/handlebars/utils.js

  escape =
    "&": "&amp;"
    "<": "&lt;"
    ">": "&gt;"
    '"': "&quot;"
    "'": "&#x27;"
    "`": "&#x60;"

  badChars = /[&<>"'`]/g
  possible = /[&<>"'`]/

  escChar = (char) -> escape[char]

  return (string) ->
    string = '' + string
    return string unless possible.test string
    string.replace badChars, escChar

beginningOfLine = /^/mg
emptyLines = /^\s+$/mg

module.exports = (input) ->
  # smal.Parser().parse(input)
  ''
