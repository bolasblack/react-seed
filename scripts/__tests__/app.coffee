React = require 'react'
TestUtils = require 'react-addons-test-utils'

jest.dontMock 'scripts/app'

describe 'App', ->
  it 'works', ->
    App = require 'scripts/app'
    app = TestUtils.renderIntoDocument(<App />)
    pageContainer = TestUtils.findRenderedDOMComponentWithClass(app, 'app-page')
    expect(pageContainer.textContent).toEqual 'It works'
