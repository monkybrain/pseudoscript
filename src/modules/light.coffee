Module = require "./module"

class Light extends Module

  constructor: (@ref) ->
  # TODO: MOVE THIS TO PARENT (IF POSSIBLE)
    @properties = {}
    for k, v of Light.properties
      @properties[k] = v.default


  @self: 'Light'

  @lexical:
    base: 'light'

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

module.exports = Light