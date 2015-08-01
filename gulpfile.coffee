
_ = require 'lodash'
st = require 'st'
http = require 'http'
browserify = require 'browserify'

gulp = require 'gulp'
gulp_source = require 'vinyl-source-stream'
gulp_livereload = require 'gulp-livereload'

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
    .pipe gulp_livereload()

gulp.task 'fe:scripts', ->
  browserify('scripts/app.coffee', browserifyOpts)
    .bundle()
    .pipe gulp_source 'app.js'
    .pipe gulp.dest 'public/scripts'
    .pipe gulp_livereload()

gulp.task 'fe:styles', ->
  gulp_sass = require 'gulp-sass'
  gulp.src 'styles/app.sass'
    .pipe gulp_sass()
    .pipe gulp.dest 'public/styles'
    .pipe gulp_livereload()

gulp.task 'fe:assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest 'public'
    .pipe gulp_livereload()

gulp.task 'fe:watch', ->
  gulp_livereload.listen()
  gulp.watch('scripts/vendor.coffee', ['fe:scriptsVendor'])
  gulp.watch('scripts/app.coffee', ['fe:scripts'])
  gulp.watch('styles/**/*', ['fe:styles'])
  gulp.watch('assets/**/*', ['fe:assets'])

gulp.task 'fe:staticServer', (done) ->
  http.createServer(
    st(path: __dirname + '/public', index: 'index.html', cache: false)
  ).listen (process.env.PORT or '9090'), ->
    console.log 'Static server listening at 9090'
    done()

gulp.task 'fe:build', ['fe:scriptsVendor', 'fe:scripts', 'fe:styles', 'fe:assets']
gulp.task 'default', ['fe:build', 'fe:staticServer', 'fe:watch']
