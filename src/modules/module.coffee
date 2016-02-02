Find = require "./../core/find"

class Module

  @index: 0

  @members: []

  @children: []

  @parent: null

  @current: null

  @add: (ref, parent) ->

    # Add to self
    Module.members.push module: this.self, ref: ref
    this.members.push ref
    this.index++

    # Add to parent (if specified)
    # TODO: Implement!

  @fetch: (ref) ->
    for member in @members
      if member.ref is ref
        return member

  ###@select: (ref) ->
    for member in @members
      if ref is member.ref
        this.current is member###

  constructor: (ref) ->
    # this.members.push ref

module.exports = Module
