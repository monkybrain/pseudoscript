class Parent

  @members: []

  constructor: (ref) ->
    Parent.members.push ref

module.exports = Parent