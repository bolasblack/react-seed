require('babel-register')(require('./.babelrc')({modules: 'commonjs'}))
module.exports = require('./gulpfile.babel.js')
