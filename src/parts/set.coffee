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
        object = @scope.object.type = mod.lexical.base

        # Find reference
        ref = Util.find.string(segment, object)
        if ref?
          @scope.object.ref = ref

        module = mod
        usingScope = false
        break
    if not object?
      object = @scope.object.type
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
        property = key

        # Remove verb and property
        if usingScope
          index = segment.indexOf property
          value = segment.slice index + property.length + 1

        if not usingScope
          if ref?
            index = segment.indexOf ref
            value = segment.slice index + ref.length + 1
          else
            index = segment.indexOf object
            value = segment.slice index + object.length + 1

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
