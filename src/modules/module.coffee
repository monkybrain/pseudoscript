class Module

  @index: 0

  @members: []

  constructor: () ->
    # Set default values
    @properties = {}
    for key, value of @constructor.properties
      @properties[key] = value.default

  @add: (ref) ->
    Module.members.push module: this.self, ref: ref
    this.members.push ref
    this.index++

  @fetch: (ref) ->
    for member in @members
      if ref is member.ref
        return member

module.exports = Module
