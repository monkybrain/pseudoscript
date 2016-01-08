class Light

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