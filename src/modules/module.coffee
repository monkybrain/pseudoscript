Find = require "./../core/find"

class Module
  # 'Module' already taken

  @index: 0

  @members: []

  @children: []

  @parent: null

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

module.exports = Module
