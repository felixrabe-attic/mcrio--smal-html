coffee = require 'gulp-coffee'
gulp = require 'gulp'
gutil = require 'gulp-util'
mocha = require 'gulp-mocha'
rimraf = require 'rimraf'

errorOccurred = no
process.once 'exit', (code) ->
  if errorOccurred and code == 0
    process.exit 1

handleError = (done = ->) -> (err) ->
  errorOccurred = yes
  if err.name and err.stack
    err = gutil.colors.red("#{err.plugin}: #{err.name}: ") +
          gutil.colors.bold.red("#{err.message}") +
          "\n#{err.stack}"
  gutil.log err
  done(err)
  @emit 'end'

gulp.task 'clean', (done) ->
  rimraf './lib', done

gulp.task 'build', ['clean'], (done) ->
  storeError = do ->
    fn = (err) -> fn.err = err
    fn.err = undefined
    fn
  buildEnd = do ->
    buildCounter = 1
    -> done(storeError.err) unless --buildCounter
  gulp.src './lib-src/**/*.coffee'
    .pipe coffee(bare: true).on 'error', handleError(storeError)
    .pipe gulp.dest './lib'
    .on 'end', buildEnd
  undefined

gulp.task 'test', ['build'], ->
  gulp.src './test/**/*.coffee', read: false
    .pipe mocha().on 'error', handleError()

gulp.task 'watch', ->
  gulp.watch [
    './lib-src/**/*.coffee'
    './test/**/*.coffee'
  ], ['test']

gulp.task 'default', ['watch', 'test']
