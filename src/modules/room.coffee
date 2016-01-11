Module = require "./module"

class Room extends Module

  @self: 'Room'

  @properties:
    'dark':
      type: 'boolean'
      set: false
    'temperature':
      type: 'number'
      set: false
    'threshold':
      type: 'number'
      set: true

  @lexical:
    base: 'room'

module.exports = Room