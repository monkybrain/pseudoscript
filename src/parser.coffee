tools = require "monky-tools"

log = tools.console.log
error = tools.console.error

class Finder

  constructor: (dictionary, map) ->
    @dict = dictionary
    @map = map

  verb: (clause) ->
    for entry, definition of @dict.verbs
      match = clause.match entry
      if match?
        return definition

  object: (clause) ->
    for key, object of @map
      match = clause.match object.word
      if match?
        return object.word

  property: (clause, object) ->
    for key, obj of @map
      if obj.word is object
        for property of obj.properties
          match = clause.match property
          if match?
            return property

  value: (clause) ->
    pattern = new RegExp("(to )|(by )")
    match = clause.match pattern
    if match?
      value = clause.slice match.index
      value = value.replace match[0], ""
      value = value.split(" ")[0]
      return value

  unit: (clause) ->
    for entry, definition of @dict.units
      match = clause.match definition.pattern
      if match?
        return entry

  reference: (clause) ->
    pattern = /"|'/g
    indices = []
    loop
      match = pattern.exec clause
      if match? then indices.push match.index else break
    if indices.length > 0
      start = indices[0] + 1
      end = indices[1]
      reference = clause[start...end]
    reference

class Parser

  constructor: (dictionary, map) ->
    @dict = dictionary
    @map = map
    @find = new Finder(@dict, @map)
    @scope =
      verb: null
      object:
        class: null
        ref: null
      indirect:
        class: null
        ref: null
      property: null

  separate: (line) ->
    line = line.toLowerCase()
    conjunctions = /( and )|(, )/g
    clauses = line.split conjunctions
    clauses = clauses.filter (clause) ->
      if not clause?
        return false
      return not clause.match conjunctions
    return clauses


  ###separate: (line) ->

    # Remove conjunctions and punctuation
    ignore = new RegExp "(and)|,|!", "g"
    line = line.replace ignore, " "

    # Define separators (verbs in dictionary) and generate regular expression
    separators = Object.keys(@dict.verbs).map (separator) ->
      "(" + separator + ")"
    pattern = new RegExp separators.join("|"), "g"

    # Get indices of parts
    indices = []
    loop
      result = pattern.exec line
      if result is null then break else indices.push result.index

    # Split string according to indices
    clauses = []
    for num, i in indices
      if indices[i+1]?
        clauses.push line[indices[i]...indices[i+1]].trim()
      else
        clauses.push line[indices[i]...].trim()

    clauses###

  parse: (line) ->

    clauses = @separate line
    clauses = clauses.map (clause) ->
      text: clause

    for clause in clauses

      ### VERB ###
      verb = @find.verb clause.text
      if verb?
        clause.type = 'verb phrase'

        @scope.verb = clause.verb = verb.type

        # Find property (if attached to verb)
        if verb.property?
          @scope.propery = clause.property = verb.property

        # Find value (if attached to verb)
        if verb.value?
          @scope.value = clause.value = verb.value

      else
        clause.verb = @scope.verb

      ### OBJECT - TYPE ###
      type = @find.object clause.text
      if type?
        object = type: type
        @scope.object = clause.object = object
      else
        clause.object = @scope.object

      ### OBJECT - REFERENCE ###
      reference = @find.reference clause.text
      if reference?
        @scope.object.ref = clause.object.ref = reference
      else
        clause.object.ref = @scope.object.ref

      ### PROPERTY ###
      property = @find.property clause.text, @scope.object.type
      if property?
        @scope.property = clause.property = property
      else
        clause.property = @scope.property

      ### VALUE ###
      value = @find.value clause.text
      if value?
        value = parseFloat(value)
        @scope.value = clause.value = value
      else
        clause.value = @scope.value

      ### UNITS ###
      if typeof clause.value is 'number'
        unit = @find.unit clause.text
        if unit?
          @scope.unit = clause.unit = unit
        else
          clause.unit = @scope.unit

    clauses

module.exports = Parser