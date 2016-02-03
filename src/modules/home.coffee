Module = require "./module"

class Home extends Module

  @self: 'Home'

  @lexical:
    base: 'home'
    plural: 'homes'

  @members = []

  @properties: {}

  constructor: () ->
    super()

module.exports = Home