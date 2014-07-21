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

subIsString = (sub) ->
  sub.length == 1

subIsAttribute = (sub) ->
  false

parseSub = (sub) ->
  if subIsString sub
    sub[0]
  else
    "\n  #{JSON.stringify sub}\n"

elementIsEmpty = (element) ->
  element[1].length == 0

parseElement = (element) ->
  tag = element[0]
  if elementIsEmpty element
    "<#{tag}/>"
  else
    s = "<#{tag}>"
    s += (parseSub sub for sub in element[1]).join ''
    s += "</#{tag}>"
    s

module.exports = (input) ->
  (parseElement el for el in smal.Parser().parse(input)).join ''
