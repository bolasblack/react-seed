_ = require 'lodash'
fs = require 'fs'
jest = require 'jest-cli'
webpack = require 'webpack'
webpackDevServer = require "webpack-dev-server"

gulp = require 'gulp'
gulp_util = require 'gulp-util'
gulp_sass = require 'gulp-sass'

webpackConfig = require './webpack.config.coffee'
webpackCompiler = webpack webpackConfig

# from https://webpack.github.io/docs/usage-with-gulp.html
gulp.task 'scripts', (done) ->
  webpackCompiler.run (err, stats) ->
    console.log 'scripts compiled'
    throw new gulp_util.PluginError("webpack", err) if err
    console.log stats.toString colors: true, chunks: false
    done()

gulp.task 'styles', ->
  gulp.src 'styles/vendor.sass'
    .pipe gulp_sass()
    .pipe gulp.dest 'public/styles'

gulp.task 'assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest 'public'

gulp.task 'jest', (done) ->
  packageInfo = JSON.parse fs.readFileSync './package.json'
  jest.runCLI packageInfo.jest, __dirname, (result) -> done()

gulp.task 'watch', (callback) ->
  gulp.watch 'scripts/**/*', gulp.series 'jest'
  gulp.watch 'styles/**/*', gulp.series 'styles'
  gulp.watch 'assets/**/*', gulp.series 'assets'

  devServer = new webpackDevServer(webpackCompiler,
    hot: true
    # inline: true
    contentBase: "./public/"
    publicPath: '/scripts'
    watchOptions:
      aggregateTimeout: 100
      poll: 300
    stats:
      colors: true
      chunks: false
  )
  devServer.listen 9090, "127.0.0.1", (err) ->
    throw new gulp_util.PluginError("webpack-dev-server", err) if err
    gulp_util.log "webpack-dev-server started at http://127.0.0.1:9090"

  return

gulp.task 'build', gulp.parallel 'scripts', 'styles', 'assets'
gulp.task 'default', gulp.series gulp.parallel('styles', 'assets'), 'watch'
