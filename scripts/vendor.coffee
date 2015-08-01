
window._ = require 'lodash'
window.moment = require 'moment'
window.Promise = require 'bluebird'
window.React = require 'react/addons'
window.ReactBootstrap = require 'react-bootstrap'
window.Backbone = require 'backbone'

ajax = require 'component-ajax'
Backbone.ajax = (options = {}) ->
  xhr = null
  promise = new Promise (resolve, reject) ->
    {success, error} = options
    options.success = (data, textStatus, xhr) ->
      resolve data
      success? data, textStatus, xhr
    options.error = (xhr, textStatus, errorThrown) ->
      reject xhr
      error? xhr, textStatus, errorThrown
    xhr = ajax options
  promise.xhr = xhr
  promise
