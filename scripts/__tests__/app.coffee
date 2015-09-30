React = require 'react/addons'

jest.dontMock 'scripts/app'

describe 'App', ->
  it 'works', ->
    TestUtils = React.addons.TestUtils
    App = require 'scripts/app'
    app = TestUtils.renderIntoDocument(<App />)
    pageContainer = TestUtils.findRenderedDOMComponentWithClass(app, 'app-page')
    expect(pageContainer.getDOMNode().textContent).toEqual 'It works'
