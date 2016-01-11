modules = require "../modules/modules"
Find = require "./find"
Scope = require "./scope"

class Set

  @lexical:
    base: 'set'
    synonyms: []

  @parse: (segment) ->

    object = Find.object segment
    module = Find.module segment

    # Find reference
    ref = Find.reference segment

    # Update scope
    Scope.object = object
    Scope.ref = ref

    # Set module
    current = module

    console.log current

    # Unset 'using scope' flag
    usingScope = false

    if not object?
      object = @scope.object.type
      ref = Find.reference(segment, object)
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
    for key, value of current.properties
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
        type: current.self
        ref: ref
      property: property
      value: value
    return operation

  @split: (text) ->
    # Define delimiter pattern
    pattern = /and|,|&/g
    # Split by pattern
    parts = text.split pattern
    # Return array of trimmed strings
    parts.map (part) ->
      part.trim()

  @test: (text) ->
    pattern = /\bset .*( to)? \b(.*)\b/g
    match = text.match pattern
    if match?
      split = @split match[0]
      segments = split.map (segment) =>
        @parse segment

      return type: 'verb', subtype: 'set', operations: segments

module.exports = Set
