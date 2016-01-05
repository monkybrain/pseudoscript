tools = require "monky-tools"

log = tools.console.log
error = tools.console.error

class Finder

  capitalize: (string) ->
    string = string[0].toUpperCase() + string[1..]

  constructor: (dictionary, map) ->
    @dict = dictionary
    @map = map

  adverb: (clause) ->
    for entry, definition of @dict.adverbs
      match = clause.match new RegExp entry
      if match?
        return definition

  event: (clause) ->
    for entry, definition of @dict.events
      match = clause.match new RegExp entry
      if match?

        object = {}

        # Find reference...
        ref = @reference clause
        if ref?
          object.ref = ref

        # If no reference -> find type
        if not ref?
          object.type = @object clause

        # Find event
        for key, value of @map
          if value.events?
            for k, v of value.events
              match = clause.match k
              if match?
                return object: object, event: match[0]

  verb: (clause) ->
    for entry, definition of @dict.verbs
      match = clause.match new RegExp entry
      if match?
        return definition

  object: (clause) ->
    for key, object of @map
      match = clause.match object.word
      if match?
        return object.word

  property: (clause, object) ->
    for key, obj of @map
      # if obj.word is object
      for property of obj.properties
        match = clause.match property
        if match?
          return property

  value: (clause) ->

    # If value defined in dictionary -> return dictionary value
    verb = @verb clause
    if verb?
      if verb.value?
        return verb.value

    # Else -> match patterns
    pattern = new RegExp("(to )|(by )")
    match = clause.match pattern
    if match?
      value = clause.slice match.index
      value = value.replace match[0], ""
      value = value.split(" ")[0]
      return value
    # TODO: FIX THIS HACK!
    pattern = /\d+ time(s)|( )/g
    match = pattern.exec clause
    if match?
      value = clause.slice match.index
      value = value.replace "times", ""
      if not isNaN parseInt value
        value = parseInt value
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
        type: null
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

  parse: (line) ->

    clauses = @separate line
    clauses = clauses.map (clause) ->
      text: clause

    for clause in clauses

      ### ADVERB ###
      adverb = @find.adverb clause.text
      if adverb?
        clause.type = 'adverbial phrase'
        clause.adverb = adverb.type
        match = clause.adverb.match /(delay)|(interval)/g
        if match?
          clause.value = @find.value clause.text
          clause.unit = @find.unit clause.text
        continue

      ### EVENT ###
      event = @find.event clause.text
      if event?
        clause.type = 'event phrase'
        clause.object = event.object
        clause.event = event.event
        continue

      ### VERB ###
      verb = @find.verb clause.text
      if verb?
        clause.type = 'verb phrase'

        @scope.verb = clause.verb = verb.type

        # Find property (if attached to verb)s
        if verb.property?
          @scope.property = clause.property = verb.property

        # Find value (if attached to verb)
        if verb.value?
          @scope.value = clause.value = verb.value

      else
        clause.verb = @scope.verb

      ### OBJECT - REFERENCE ###
      ref = @find.reference clause.text
      if ref?
        object = ref: ref
        @scope.object = clause.object = object
      else
        clause.object = @scope.object

      ### OBJECT - TYPE ###

      type = @find.object clause.text
      if type?
        object.type = type
        @scope.object = clause.object = object
      else
        clause.object = @scope.object

      ### PROPERTY ###
      property = @find.property clause.text, @scope.object.type
      if property?
        @scope.property = clause.property = property
      else
        clause.property = @scope.property

      ### VALUE ###
      value = @find.value clause.text
      if value?
        value = if isNaN parseFloat value then value else parseFloat value
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

      console.log @scope

    clauses

module.exports = Parser