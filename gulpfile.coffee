_ = require 'lodash'
http = require 'http'
webpack = require 'webpack'
webpackDevServer = require "webpack-dev-server"
webpackConfig = require './webpack.config'

gulp = require 'gulp'
gulp_util = require 'gulp-util'
gulp_sass = require 'gulp-sass'
gulp_webpack = require 'webpack-stream'

# from https://github.com/milankinen/livereactload/blob/master/examples/05-build-systems/gulpfile.js
gulp.task 'fe:scripts', ->
  gulp.src 'scripts/index.coffee'
    .pipe(gulp_webpack webpackConfig)
    .pipe gulp.dest 'public/scripts'

gulp.task 'fe:styles', ->
  gulp.src 'styles/vendor.sass'
    .pipe gulp_sass()
    .pipe gulp.dest 'public/styles'

gulp.task 'fe:assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest 'public'

gulp.task 'fe:watch', (callback) ->
  gulp.watch('styles/**/*', ['fe:styles'])
  gulp.watch('assets/**/*', ['fe:assets'])

  devServer = new webpackDevServer(webpack(webpackConfig),
    hot: true
    contentBase: './public/'
    watchOptions:
      aggregateTimeout: 100
      poll: 300
    noInfo: true
  )
  devServer.listen 9090, "127.0.0.1", (err) ->
    throw new gulp_util.PluginError("webpack-dev-server", err) if err
    gulp_util.log "webpack-dev-server started at http://127.0.0.1:9090"
    callback()

  return

gulp.task 'fe:build', ['fe:scripts', 'fe:styles', 'fe:assets']
gulp.task 'default', ['fe:build', 'fe:watch']
