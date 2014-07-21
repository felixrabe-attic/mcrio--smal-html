#!/usr/bin/env coffee

fs = require 'fs'

inputFilename = __dirname + '/html-attributes.json'
outputFilename = __dirname + '/html-attributes-by-tag.json'

json = JSON.parse fs.readFileSync inputFilename, 'utf8'
tags = {}
for row in json.rows
  (tags[row['Tag']] ?= []).push row['Attribute']

fs.writeFileSync outputFilename, JSON.stringify(tags, null, 2), 'utf8'
