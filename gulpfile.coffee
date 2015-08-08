
_ = require 'lodash'
http = require 'http'
lrload = require 'livereactload'
watchify = require 'watchify'
browserify = require 'browserify'

gulp = require 'gulp'
gulp_util = require 'gulp-util'
gulp_source = require 'vinyl-source-stream'
gulp_webserver = require 'gulp-webserver'

# from https://github.com/milankinen/livereactload/blob/master/examples/05-build-systems/gulpfile.js
gulp.task 'fe:scripts', do ->
  browserifyOpts = {
    entries: ['scripts/app.coffee']
    transform: ['coffee-reactify', 'aliasify', 'livereactload']
    extensions: ['.coffee']
    cache: {}
    packageCache: {}
    fullPaths: true # for watchify
  }

  lrload.monitor 'public/scripts/app.js', displayNotification: true
  rebundle = ->
    gulp_util.log 'Update JavaScript bundle'
    watcher.bundle()
      .on 'error', gulp_util.log
      .pipe gulp_source 'app.js'
      .pipe gulp.dest 'public/scripts'
  bundler = browserify browserifyOpts
  watcher = watchify(bundler).on('error', gulp_util.log).on 'update', rebundle

  ->
    rebundle()

gulp.task 'fe:styles', ->
  gulp_sass = require 'gulp-sass'
  gulp.src 'styles/app.sass'
    .pipe gulp_sass()
    .pipe gulp.dest 'public/styles'

gulp.task 'fe:assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest 'public'

gulp.task 'fe:watch', ->
  gulp.watch('scripts/**/*', ['fe:scripts'])
  gulp.watch('styles/**/*', ['fe:styles'])
  gulp.watch('assets/**/*', ['fe:assets'])
  gulp.src('./public').pipe gulp_webserver(
    port: 9090
    livereload:
      enable: true
      filter: (fileName) ->
        return false if fileName.match /\.js$/
        true
  )

gulp.task 'fe:build', ['fe:scripts', 'fe:styles', 'fe:assets']
gulp.task 'default', ['fe:build', 'fe:watch']
