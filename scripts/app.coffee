require 'scripts/vendor'
require 'styles/app'

App = React.createClass(
  render: ->
    <div className="app-page">It works</div>
)

React.render(
  <App />
  document.getElementById('app')
)
