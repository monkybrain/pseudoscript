Find = require "./../parts/find"

class Module

  @index: 0

  @members: []

  @children: []

  @parent: null

  constructor: () ->
    # Set default values
    @properties = {}
    for key, value of @constructor.properties
      @properties[key] = value.default

  @add: (ref, parent) ->

    # Add to self
    Module.members.push module: this.self, ref: ref
    this.members.push ref
    this.index++

    # Add to parent (if specified)
    # TODO: Implement!

  @fetch: (ref) ->
    for member in @members
      if ref is member.ref
        return member

module.exports = Module
