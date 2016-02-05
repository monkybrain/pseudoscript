### VERB: GET ###

modules = require "../../modules/modules"
Module = require "../../modules/module"
Scope = require "./../scope"
Find = require "./../../core/find"
Verb = require "./verb"
Util = require "./../../core/util"

class Get extends Verb

  @lexical:
    base: 'get'
    synonyms: ['get']

  @getObject: (segment) ->

    ### FIND OBJECT AND REFERENCE ###

    # Search for object
    for module in modules
      words = [module.lexical.base, module.lexical.plural]
      pattern = Util.regex.groupAndBound words
      match = segment.match pattern
      if match?
        object = module.self
        break

    # Search for reference
    refs = Find.references segment
    if refs?
      ref = refs[0]

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
      ###if ref?
        try
          object = Module.fetch(ref).module
        catch err
          console.error "Error! '#{ref}' not found."###
      # ...else ->
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

  @parse: (segment) ->

    # Get object
    [object, ref] = @getObject segment

    # Get property and convert to short form
    property = @getProperty segment, object
    property = Find.module(object).properties[property].key

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
      operations = []
      for segment in split
        details = @parse segment
        run = true
        for operation in operations
          # If already exists -> set properties
          if operation.ref is details.ref
            operation.properties.push details.property
            run = false
        if run
          properties = []
          properties.push details.property
          operations.push object: details.object, ref: details.ref, properties: properties

      return type: 'verb', verb: 'get', operations: operations

  @syntax: (phrase, level) ->
    syntax = []
    for operation in phrase.operations
      {object: object, ref: ref, properties: properties} = operation

      props = []
      for property in properties
        props.push "'#{property}'"

      syntax.push "# Get properties of '#{ref}'"
      prefix = if level isnt 0 then ".then -> " else ""
      syntax.push prefix + "#{object}.get '#{ref}', " + props.join ", "

      syntax.push ".then (result) -> Globals.set result\n"
      # syntax.push "  Globals[key] = value for key, value of response"
      # syntax.push "  Util.promise response\n"

    syntax

module.exports = Get
