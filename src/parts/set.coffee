modules = require "../modules/modules"
Util = require "./util"

class Set

  constructor: (dict) ->
    @dict = dict
    @scope = object: {}

  parse: (segment) ->

    # Find object
    for mod in modules
      match = segment.match mod.lexical.base
      if match?

        # Set 'object' to corresponding word # TODO: FIX, NOT SO ELEGANT
        object = mod.lexical.base

        # Find reference
        ref = Util.find.string(segment, object)

        # Update scope
        @scope.object.type = object
        @scope.object.ref = ref

        # Set module
        module = mod

        # Unset 'using scope' flag
        usingScope = false

        break

    if not object?
      object = @scope.object.type
      ref = Util.find.string(segment, object)
      if ref?
        @scope.object.ref = ref
      else
        ref = @scope.object.ref
      for mod in modules
        if object is mod.lexical.base
          module = mod
          break
      usingScope = true
    if not object?
      console.error "No object"
      return object: null

    # Find property
    for key, value of module.properties
      match = segment.match key
      if match?
        property = @scope.property = key
        break
    if not property?
      property = @scope.property
    if not property?
      console.error "No property specified"
      return

    # Remove verb and property
    indices = [
      {index: segment.indexOf(property), string: property},
      {index: segment.indexOf(ref), string: ref},
      {index: segment.indexOf(object), string: object}
    ]

    indices.sort (a, b) ->
      a.index < b.index
    index = indices[0]
    value = segment.slice index.index + index.string.length + 1

    # Remove preposition (if exists)
    pattern = /\bto\b/g
    value = value.replace(pattern, "").trim()

    operation =
      object:
        type: module.self
        ref: ref
      property: property
      value: value
    return operation

  split: (text) ->
    # Define delimiter pattern
    pattern = /and|,|&/g
    # Split by pattern
    parts = text.split pattern
    # Return array of trimmed strings
    parts.map (part) ->
      part.trim()

  test: (text) ->
    pattern = /\bset .*( to)? \b(.*)\b/g
    match = text.match pattern
    if match?
      split = @split match[0]
      segments = split.map (segment) =>
        @parse segment

      return type: 'verb', subtype: 'set', operations: segments

module.exports = Set
