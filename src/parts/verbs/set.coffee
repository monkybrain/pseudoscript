### VERB: SET (BASED ON GET) ###

modules = require "../../modules/modules"
Find = require "./../../core/find"
Scope = require "./../scope"
Get = require "./get"
Util = require "./../../core/util"

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
      # Check for random
      match = segment.match "random"
      if match?
        value = 'random'
      else
        value = parseFloat Find.number segment

    if type is 'boolean'
      value = Find.boolean segment
      console.log value

    if type is 'string'

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
      pattern = /(\bto\b)/
      match = value.match pattern
      if match?
        index = match.index + "to".length
        value = value[index...].trim()

    return value

  @parse: (segment) ->

    # Get object
    [object, ref] = @getObject segment

    # Get property (long form)
    property = @getProperty segment, object

    # Get value
    value = @getValue segment, object, ref, property

    # Convert long form property to short form (must be done after getting value)
    property = Find.module(object).properties[property].key

    # TODO: Implement 'boolean' and 'string'

    # Update scope
    Scope.current = object: object, ref: ref, property: property, value: value
    Scope.modules[object] = ref: ref, property: property, value: value

    # Return parsed info
    return object: object, ref: ref, property: property, value: value

  @test: (text) ->

    pattern = /\bset .*( to)? \b(.*)\b/g
    match = text.match pattern
    if match?
      split = @split match[0]

      # TODO: UGLY! CLEAN UP AND BEAUTIFY!
      operations = []
      for segment in split
        details = @parse segment
        run = true
        for operation in operations
          # If already exists -> set properties
          if operation.ref is details.ref
            operation.properties[details.property] = details.value
            run = false
        if run
          properties = {}
          properties[details.property] = details.value
          operations.push object: details.object, ref: details.ref, properties: properties

      return type: 'verb', verb: 'set', operations: operations, input: text

  @random: (object, property) ->
    [module] = modules.filter (module) -> module.self is object
    for k, v of module.properties
      if k is property
        max = v.max
        min = v.min
    max: max, min: min

  @syntax: (phrase, level) ->
    # console.log "Set level: " + phrase + " --> " + level
    syntax = []
    for operation in phrase.operations
      {object: object, ref: ref, properties: properties} = operation
      options = []
      for key, value of properties
        if value is 'random'
          r = @random object, key
          value = "Util.random min: #{r.min}, max: #{r.max}"
        options.push "  #{key}: #{value}"
      # options[options.length - 1] = options[options.length - 1] + "\n"
      syntax.push "# Set properties of '#{ref}'"
      prefix = if level isnt 0 then ".then -> " else ""
      syntax.push prefix + "#{object}.set '#{ref}', "
      syntax.push option for option in options
      syntax.push ".then (result) -> Globals.set result\n"

    syntax

module.exports = Set
