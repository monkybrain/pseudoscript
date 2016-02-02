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
      key: 'on'
      type: 'boolean'
      operations: ['set', 'get']
      default: true
    'color':
      operations: ['set']
      type: 'string'
      set: true
      default: 'white'
    'hue':
      key: 'hue'
      type: 'number'
      operations: ['set', 'get']
      min: 0
      max: 65535
      default: 20000
    'saturation':
      key: 'saturation'
      type: 'number'
      operations: ['set', 'get']
      min: 0
      max: 254
      default: 200
    'brightness':
      key: 'brightness'
      type: 'number'
      operations: ['set', 'get']
      min: 0
      max: 254
      default: 100
    'transition time':
      key: 'transitionTime'
      type: 'number'
      operations: ['set']
      default: 1

  constructor: (@ref) ->

    # TODO: Fix wicked synchronous pause!
    Hue.ready().then () =>

      [light] = Hue.lights.filter (light) =>
        light.attributes.attributes.name is @ref

      if not light?
        console.error "Error! Hue light '#{@ref}' not found"
        process.exit()

      @id = light.attributes.attributes.id
      console.log

      @properties = {}
      for k, v of Light.properties
        @properties[k] = if 'get' in v.operations then light.state.attributes[v.key] else null

      # Set default properties
      # TODO: Move to parent if possible!
      @properties = {}
      for k, v of Light.properties
        @properties[k] = v.default

      Light.members.push this

  @set: (ref, options) ->

    new Promise (resolve, reject) =>

      Hue.ready().then () =>
        [@current] = Light.members.filter (member) => member.ref is ref
        if not @current? then reject "Error! Cannot find '#{ref}'"

        # Set properties
        Hue.light.set(@current.id, options)
        .then -> resolve()
        .catch (err) -> reject "Error! " + error.message

  @get: (ref, properties...) ->

    new Promise (resolve, reject) =>

      Hue.ready().then () =>
      [@current] = Light.members.filter (member) => member.ref is ref
      if not @current? then reject "Error! Cannot find '#{ref}'"

      # Set properties
      Hue.light.get(@current.id, properties).then(
        (properties) => resolve properties
        (error) -> reject "Error! " + error.message
      )

module.exports = Light