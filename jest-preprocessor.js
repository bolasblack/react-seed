var coffee = require('coffee-script')
var coffeeReact = require('coffee-react')

module.exports = {
  process: (src, path) => {
    // CoffeeScript files can be .coffee, .litcoffee, or .coffee.md
    if (coffee.helpers.isCoffee(path)) {
      return coffeeReact.compile(src, {bare: true})
    } else if (/\.(sass|scss|css)$/.test(path)) {
      return ''
    } else {
      return src
    }
  }
}
