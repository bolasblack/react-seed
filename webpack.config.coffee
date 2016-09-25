_ = require 'lodash'
sysPath = require 'path'
webpack = require 'webpack'

config = {
  context: sysPath.resolve('.')
  entry: ['./scripts/index.coffee']
  resolveLoader:
    modulesDirectories: ['node_modules']
  resolve:
    extensions: ['', '.js', '.coffee', '.sass']
  module:
    loaders: [
      {test: /\.css$/, loader: 'style!css'}
      {test: /\.sass$/, loader: 'style!css!sass?indentedSyntax'}
      {test: /\.coffee$/, loader: 'react-hot-loader/webpack!coffee!cjsx'}
    ]
  output:
    path: sysPath.resolve('./public')
    publicPath: '/'
    filename: '[name].js'
  devtool: 'source-map'
}

if process.env.NODE_ENV isnt 'production'
  config = _.extend {}, config, {
    watch: true
    entry: _.flatten([
      "webpack-dev-server/client?http://127.0.0.1:9090"
      "webpack/hot/dev-server"
      "react-hot-loader/patch"
      config.entry.slice(0)
    ])
    plugins: [
      new webpack.HotModuleReplacementPlugin()
    ]
  }
else
  config = _.extend {}, config

module.exports = config
