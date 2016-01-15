Find = require "./../core/find"

class Module
  # 'Module' already taken

  @index: 0

  @members: []

  @children: []

  @parent: null

  ###
  constructor: (ref) ->
    console.log "Module: " + ref
    return
    # Set default values
    @properties = {}
    for key, value of @constructor.properties
      @properties[key] = value.default
  ###

  constructor: (@ref) ->

  @add: (ref, parent) ->

    # Add to self
    Module.members.push module: this.self, ref: ref
    this.members.push ref
    this.index++

    # Add to parent (if specified)
    # TODO: Implement!

  @select: (ref) ->
    for member in @members
      if ref is member.ref
        return member

fisk = new Module 'test'

console.log fisk
module.exports = Module
