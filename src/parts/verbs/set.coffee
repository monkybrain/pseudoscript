### VERB: SET (BASED ON GET) ###

modules = require "../../modules/modules"
Find = require "./../find"
Scope = require "./../scope"
Get = require "./get"

class Set extends Get

  @lexical:
    base: 'set'
    synonyms: ['set']

  @getValue: (segment, object, ref, property) ->

    # Get module
    module = Find.module object

    try
      type = module.properties[property].type
    catch err
      console.error "Error! Invalid property in segment '#{segment}'"

    if type is 'number'
      value = parseFloat Find.number segment

    if type is 'string'

      # pattern = /to .*/g
      # match = segment.match pattern
      # if match?
      #   preposition = match[0]

      # Get indices of object, ref and property
      occurrences = [
        {string: module.lexical.base, index: segment.indexOf module.lexical.base},
        {string: ref, index: segment.indexOf ref},
        {string: property, index: segment.indexOf property}
      ]

      # Sort by highest index and get last occurrence
      occurrences.sort (a, b) ->
        a.index < b.index
      occurrence = occurrences[0]

      # value = segment.slice index.index + index.string.length + 1
      value = segment.slice occurrence.index + occurrence.string.length + 1

      # Remove preposition (if exists)
      pattern = /\bto\b/g
      value = value.replace(pattern, "").trim()

    return value

  @parse: (segment) ->

    # Get object
    [object, ref] = @getObject segment

    # Get property
    property = @getProperty segment, object

    # Get value
    value = @getValue segment, object, ref, property

    # TODO: Implement 'boolean' and 'string'

    # Update scope
    Scope.current = object: object, ref: ref, property: property, value: value
    Scope.modules[object] = ref: ref, property: property, value: value

    # Return parsed info
    return object: object, ref: ref, property: property, value: value

  @test: (text) ->

    pattern = /\bset .*( to)? \b(.*)\b/g
    match = text.match pattern
    console.log match
    if match?
      split = @split match[0]
      segments = split.map (segment) =>
        @parse segment

      return type: 'verb', subtype: 'set', operations: segments

module.exports = Set
