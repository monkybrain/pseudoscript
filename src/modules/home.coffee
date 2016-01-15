Module = require "./module"

class Home extends Module

  @self: 'Home'

  @lexical:
    base: 'home'

  @members = []

  @properties: {}

  constructor: () ->
    super()

module.exports = Home