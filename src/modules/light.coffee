Module = require "./module"
Hue = require "./hue"
util = require "util"

class Light extends Module

  @self: 'Light'

  @lexical:
    base: 'light'
    plural: 'lights'
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
    'hue':
      type: 'number'
      min: 0
      max: 65500
      default: 20000
    'saturation':
      type: 'number'
      min: 0
      max: 254
      default: 200
    'brightness':
      type: 'number'
      set: true
      default: 100

  constructor: (@ref) ->

    # TODO: Fix wicked synchronous pause!
    Hue.ready().then () =>

      # Check if valid name
      names = Hue.lights.map (light) ->
        light.attributes.attributes.name

      if @ref not in names
        console.error "Error! Hue light '#{@ref}' not found"
        # TODO: Throw error here

      # Set default properties
      # TODO: Move to parent if possible!
      @properties = {}
      for k, v of Light.properties
        @properties[k] = v.default






  set: (property, value) ->

module.exports = Light