React = require 'react'
ReactDOM = require 'react-dom'
{AppContainer} = require 'react-hot-loader'

App = require './app'

ReactDOM.render(
  <AppContainer>
    <App />
  </AppContainer>
  document.getElementById('app')
)

# Hot Module Replacement API
if module.hot
  module.hot.accept './app', ->
    NextApp = require('./app')
    ReactDOM.render(
      <AppContainer>
        <NextApp/>
      </AppContainer>
      document.getElementById('app')
    )
