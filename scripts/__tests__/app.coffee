React = require 'react'
App = require '../app'

describe 'App', ->
  beforeEach ->
    jest.resetModules()

  it 'successfully rendered', ->
    React = require('react')
    renderer = require('react-test-renderer')
    elem = renderer.create(<App />)
    tree = elem.toJSON()
    expect(tree).toMatchSnapshot()

  it 'can also response some event', ->
    onClick = jest.fn()
    React = require('react')
    {shallow} = require('enzyme')
    elem = shallow(<App onClick={onClick} />)
    elem.props().onClick()
    expect(onClick).toBeCalled()
