modules = require "../../modules/modules"
Find = require "./../find"
Scope = require "./../scope"

class Set

  @lexical:
    base: 'set'
    synonyms: []

  @parse: (segment) ->

    ### FIND OBJECT AND REFERENCE ###

    # Parse segment for object
    for module in modules
      match = segment.match module.lexical.base
      if match?
        object = module.self
        break

    # If no object -> fall back on scope
    if not object?
      object = Scope.current.object
      ref = Scope.current.ref

    # If object but no reference -> get reference from scope
    else
      ref = Scope.modules[object].ref

    ### FIND PROPERTY ###

    # Look for all properties associated with module
    module = Find.module object
    for key, value of module.properties
      match = segment.match key
      if match?
        property = key

    # If no property -> fall back on scope
    if not property?
      property = Scope.modules[object].property

    ### FIND VALUE ###
    try
      type = module.properties[property].type
    catch err
      console.error "Error! Invalid property in segment '#{segment}'"

    if type is 'number'
      value = parseFloat Find.number segment

    # TODO: Implement 'boolean' and 'string'

    # Update scope
    Scope.current = object: object, ref: ref, property: property, value: value
    Scope.modules[object] = ref: ref, property: property, value: value

    object: object, ref: ref, property: property, value: value

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
