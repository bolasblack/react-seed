const _ = require('lodash')
const sysPath = require('path')
const webpack = require('webpack')

let config = {
  context: sysPath.resolve('.'),
  entry: [
    './scripts/index.jsx',
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.json'],
    modules: [
      sysPath.resolve(__dirname, '.'),
      'node_modules',
    ],
  },
  module: {
    rules: [{
      test: /\.json$/,
      use: ['json'],
    }, {
      test: /\.sass$/,
      use: [
        'style-loader',
        'css-loader',
        {
          loader: 'sass-loader',
          options: {
            indentedSyntax: true
          },
        },
      ]
    }, {
      test: /\.jsx?$/,
      exclude: /node_modules/,
      use: [
        'react-hot-loader/webpack',
        "babel-loader",
      ],
    }],
  },
  output: {
    path: sysPath.resolve('./public/scripts'),
    publicPath: '/',
    filename: '[name].js',
  },
  /* devtool: 'source-map',*/
  plugins: [
    new webpack.NamedModulesPlugin(),
  ],
}

if (process.env.NODE_ENV !== 'production') {
  config = _.extend({}, config, {
    watch: true,
    entry: _.flatten([
      "webpack-dev-server/client?http://127.0.0.1:9090",
      "webpack/hot/dev-server",
      "react-hot-loader/patch",
      config.entry.slice(0)
    ]),
  })
  config.plugins.push(new webpack.HotModuleReplacementPlugin())
} else {
  config = _.extend({}, config)
}

module.exports = config
