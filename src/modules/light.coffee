Module = require "./module"

class Light extends Module

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