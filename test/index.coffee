they = it

expect = require('chai').expect

index = require '../'

describe 'smal-html', ->

  eq = null

  before ->
    eq = (input, expected) ->
      actual = index input
      try
        expect(actual).to.equal expected  # just compares strings, no deep equal needed
      catch err
        err.message = 'not equal'
        err.showDiff = false
        throw err

  it 'should accept empty input', ->
    eq '', ''

  it 'should accept single element', ->
    eq 'element', '<element/>'

  it 'should accept two successive elements', ->
    eq '''
      foo
      bar
    ''', '<foo/><bar/>'
