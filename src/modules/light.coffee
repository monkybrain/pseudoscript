Module = "./module"

class Light extends Module

  @self: 'Light'

  @properties:
    'on':
      type: 'boolean'
      set: true
    'color':
      type: 'string'
      set: true
    'brightness':
      type: 'number'
      set: true

  @lexical:
    base: 'light'

module.exports = Light