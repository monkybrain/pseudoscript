### VERB: GET ###

modules = require "../../modules/modules"
Module = require "../../modules/module"
Scope = require "./../scope"
Find = require "./../find"

class Get

  @lexical:
    base: 'get'
    synonyms: []

  @getObject: (segment) ->

    ### FIND OBJECT AND REFERENCE ###

    # Search for object
    for module in modules
      match = segment.match module.lexical.base
      if match?
        object = module.self
        break

    # Search for reference
    ref = Find.reference segment

    # If no object...
    if not object?
      # ...but ref -> fetch from members
      if ref?
        try
          object = Module.fetch(ref).module
        catch err
          console.error "Error! '#{ref}' not found."
      # ...else -> fetch from scope
      else
        object = Scope.current.object
        ref = Scope.current.ref

    # If object...
    else
      # ...and ref? -> fetch from members
      if ref?
        try
          object = Module.fetch(ref).module
        catch err
          console.error "Error! '#{ref}' not found."
      # ...else ->
      else
        ref = Scope.modules[object].ref

    return [object, ref]

  @getProperty: (segment, object) ->

    ### FIND PROPERTY ###

    # Get module
    module = Find.module object

    # Look for all properties associated with module
    for key, value of module.properties
      match = segment.match key
      if match?
        property = key

    # If no property -> fall back on scope
    if not property?
      property = Scope.modules[object].property

    return property

  @split: (text) ->
    # Define delimiter pattern
    pattern = /and|,|&/g
    # Split by pattern
    parts = text.split pattern
    # Return array of trimmed strings
    parts.map (part) ->
      part.trim()

  @parse: (segment) ->

    # Get object
    [object, ref] = @getObject segment

    # Get property
    property = @getProperty segment, object

    # Update scope
    Scope.current = object: object, ref: ref, property: property
    Scope.modules[object] = ref: ref, property: property

    # Return parsed info
    return object: object, ref: ref, property: property

  @test: (text) ->
    pattern = /\bget .*( to)? \b(.*)\b/g
    match = text.match pattern
    if match?
      split = @split match[0]
      segments = split.map (segment) =>
        @parse segment

      return type: 'verb', subtype: 'get', operations: segments

module.exports = Get
