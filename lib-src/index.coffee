_ = require 'lodash'
smal = require 'smal'
fs = require 'fs'

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

subIsElement = (sub) ->
  sub.length == 2

parseOtherSub = (sub) ->
  if subIsString sub
    sub[0]
  else if subIsElement sub
    parseElement sub
  else
    "\n  #{JSON.stringify sub}\n"

htmlAttributesByTag = do ->
  filename = __dirname + '/../html-attributes/html-attributes-by-tag.json'
  JSON.parse fs.readFileSync filename, 'utf8'

attributesForTag = (tag) ->
  htmlAttributesByTag['*'].concat htmlAttributesByTag[tag] ? []

isArrayWithLength = (ob, len) ->
  _.isArray(ob) and ob.length == len

parseElementSubs = (element) ->
  tag = element[0]
  attributeList = attributesForTag tag
  attributes = []
  other = []
  for sub in element[1]
    if  sub.length == 2 and
        sub[0] in attributeList and
        isArrayWithLength(sub[1], 1) and
        isArrayWithLength(sub[1][0], 1)
      attributes.push [sub[0], sub[1][0][0]]
    else
      other.push parseOtherSub sub
  [attributes, other]

attributesToString = (attributes) ->
  (" #{a[0]}=\"#{htmlEscape a[1]}\"" for a in attributes).join ''

nonSelfClosing = [
  'p'
]

parseElement = (element) ->
  tag = element[0]
  [attributes, other] = parseElementSubs element
  attrString = attributesToString attributes
  if other.length == 0 and tag not in nonSelfClosing
    "<#{tag}#{attrString}/>"
  else
    "<#{tag}#{attrString}>" + other.join('') + "</#{tag}>"

module.exports = (input) ->
  (parseElement el for el in smal.Parser().parse(input)).join ''
