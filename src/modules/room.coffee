Module = require "./module"

class Room extends Module

  @self: 'Room'

  @lexical:
    base: 'room'
    plural: 'rooms'

  @members = []

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

  constructor: () ->
    super()

module.exports = Room