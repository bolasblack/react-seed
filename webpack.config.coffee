_ = require 'lodash'
sysPath = require 'path'
webpack = require 'webpack'

config = {
  entry: [
    './scripts/app'
  ]
  resolveLoader:
    modulesDirectories: ['node_modules']
  resolve:
    extensions: ['', '.js', '.coffee']
  module:
    loaders: [
      {test: /\.css$/, loaders: ['style', 'css']}
      {test: /\.coffee$/, loaders: ["coffee-jsx-loader"]}
    ]
  output:
    path: sysPath.join(__dirname, "public")
    filename: '[name].js'
}

if process.env.NODE_ENV isnt 'production'
  config = _.extend {
    devtool: "eval"
    watch: true
    debug: true
    plugins: [
      new webpack.HotModuleReplacementPlugin()
    ]
  }, config
  config.entry.unshift "webpack-dev-server/client?http://127.0.0.1:9090", "webpack/hot/dev-server"

module.exports = config
