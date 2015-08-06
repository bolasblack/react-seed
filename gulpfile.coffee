
_ = require 'lodash'
http = require 'http'
browserify = require 'browserify'

gulp = require 'gulp'
gulp_source = require 'vinyl-source-stream'
gulp_webserver = require 'gulp-webserver'

browserifyOpts = {
  transform: ['coffee-reactify', 'aliasify']
  extensions: ['.coffee']
}

gulp.task 'fe:scriptsVendor', ->
  browserify('scripts/vendor.coffee', browserifyOpts)
    .ignore('jquery')
    .bundle()
    .pipe gulp_source 'vendor.js'
    .pipe gulp.dest 'public/scripts'

gulp.task 'fe:scripts', ->
  browserify('scripts/app.coffee', browserifyOpts)
    .bundle()
    .pipe gulp_source 'app.js'
    .pipe gulp.dest 'public/scripts'

gulp.task 'fe:styles', ->
  gulp_sass = require 'gulp-sass'
  gulp.src 'styles/app.sass'
    .pipe gulp_sass()
    .pipe gulp.dest 'public/styles'

gulp.task 'fe:assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest 'public'

gulp.task 'fe:watch', ->
  gulp.watch('scripts/vendor.coffee', ['fe:scriptsVendor'])
  gulp.watch('scripts/**/*', ['fe:scripts'])
  gulp.watch('styles/**/*', ['fe:styles'])
  gulp.watch('assets/**/*', ['fe:assets'])
  gulp.src('./public').pipe gulp_webserver(
    livereload: true
    port: 9090
  )

gulp.task 'fe:build', ['fe:scriptsVendor', 'fe:scripts', 'fe:styles', 'fe:assets']
gulp.task 'default', ['fe:build', 'fe:watch']
