import gulp from 'gulp'
import gulp_util from 'gulp-util'
import gulp_sass from 'gulp-sass'
import gulp_plumber from 'gulp-plumber'
import webpack from 'webpack'
import webpackDevServer from 'webpack-dev-server'
import colors from 'colors/safe'
import webpackConfig from './webpack.config'

const webpackCompiler = webpack(webpackConfig)

export const assets = () => {
  return gulp.src('assets/**/*')
             .pipe(gulp.dest('public'))
}

export const styles = () => {
  return gulp.src('styles/vendor.sass')
             .pipe(gulp_sass())
             .pipe(gulp.dest('public/styles'))
}

export const scripts = (done) => {
  return webpackCompiler.run((err, stats) => {
    if (err) { throw new gulp_util.PluginError("webpack", err) }
    console.log(stats.toString({colors: true, chunks: false}))
    done()
  })
}

export const watch = () => {
  gulp.watch('assets/**/*', gulp.series('assets'))
  gulp.watch('styles/**/*', gulp.series('styles'))

  const serverPromises = []

  const devServerHost = process.env.DEV_SERVER_HOST || "127.0.0.1"
  const devServerPort = process.env.DEV_SERVER_PORT || '9090'
  const devServer = new webpackDevServer(webpackCompiler, {
    hot: true,
    contentBase: "./public/",
    publicPath: '/scripts',
    watchOptions: { aggregateTimeout: 100, poll: 300 },
    stats: { colors: true, chunks: false },
  })
  const devServerPromise = new Promise((resolve, reject) => {
    devServer.listen(devServerPort, devServerHost, function(err) {
      err ? reject(err) : resolve(`webpack-dev-server started at http://${devServerHost}:${devServerPort}`)
    })
  })
  serverPromises.push(devServerPromise)

  if (process.env.REMOTE_DEV_SERVER || process.env.REMOTE_DEV_SERVER_HOST || process.env.REMOTE_DEV_SERVER_PORT) {
    const remoteDevServerHost = process.env.REMOTE_DEV_SERVER_HOST || '127.0.0.1'
    const remoteDevServerPort = process.env.REMOTE_DEV_SERVER_PORT || '19090'
    const remoteDev = require('remotedev-server')
    const remoteDevPromise = remoteDev({hostname: remoteDevServerHost, port: remoteDevServerPort}).then(() => {
      return `remotedev-server will started at http://${remoteDevServerHost}:${remoteDevServerPort}`
    })
    serverPromises.push(remoteDevPromise)
  }

  return Promise.all(serverPromises).then(messages => {
    return gulp_util.log(colors.green(`\n\n${messages.join('\n')}\n`))
  }).catch((err) => {
    return Promise.reject(new gulp_util.PluginError("webpack-dev-server", err))
  })
}

export const build = gulp.parallel(assets, scripts, styles)

export default gulp.series(
  gulp.parallel(assets, styles),
  watch,
)
