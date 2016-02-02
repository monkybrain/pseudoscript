Parent = require "./parent"

class Child extends Parent

  @members = []

  constructor: (@ref) ->
    super(@ref)
    Child.members.push @ref

module.exports = Child