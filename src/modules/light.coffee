Module = require "./module"
Hue = require "./hue"
util = require "util"

class Light extends Module

  constructor: (@ref) ->

    # TODO: Fix wicked synchronous pause!
    Hue.ready().then () ->

      # Check if valid name
      names = Hue.lights.map (light) ->
        light.attributes.attributes.name
      console.log names

      # TODO: Set default properties (move to parent if possible)
      @properties = {}
      for k, v of Light.properties
        @properties[k] = v.default






  @self: 'Light'

  @lexical:
    base: 'light'
    phrases: [
      {pattern: 'turn on <object>', verb: 'set', property: 'on', value: true},
      {pattern: 'turn <object> off', verb: 'set', property: 'on', value: true},
      {pattern: 'turn off <object>', verb: 'set', property: 'on', value: false},
      {pattern: 'turn <object> off', verb: 'set', property: 'on', value: false}
    ]

  @members: []

  @properties:
    'on':
      type: 'boolean'
      set: true
      default: true
    'color':
      type: 'string'
      set: true
      default: 'white'
    'brightness':
      type: 'number'
      set: true
      default: 100

  set: (property, value) ->

module.exports = Light