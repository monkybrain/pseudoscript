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
    match = clause.match new RegExp @dict.event
    if match?

      object = {}

      # Find reference...
      ref = @reference clause
      if ref?
        object.ref = ref

      # If no reference -> find type
      if not ref?
        object.type = @capitalize @object clause

      # Find event
      for key, value of @map
        if value.events?
          for k, v of value.events
            match = clause.match k
            if match?
              return object: object, event: v.event

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

  conditional: (clause) ->
    for k,v of @dict.conditionals
      pattern = new RegExp k
      match = clause.match pattern
      if match?
        result = type: v.type
        if result.type is 'if'
          for k2, v2 of @dict.comparisons
            pattern = new RegExp k2
            match = clause.match pattern
            if match?
              result.test = v2.type
              # Find values
              pattern = /if .*? is/
              if match?
                # Get left hand expression
                start = clause.indexOf("if") + "if".length
                end = clause.indexOf "is"
                lefthand = clause.slice(start, end).trim()
                # Get right hand expression
                start = clause.indexOf("than") + "than".length
                righthand = clause.slice(start).trim()
                if not isNaN lefthand
                  lefthand = parseFloat lefthand
                if not isNaN righthand
                  righthand = parseFloat righthand
                result.lefthand = lefthand
                result.righthand = righthand
                result

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

      ### CONDITIONALS ###
      ###conditional = @find.conditional clause.text
      if conditional?
        console.log conditional
        clause.type = 'conditional phrase'
        clause.conditional = conditional
        continue###

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
        if object?
          object.type = type
        else
          object = type: type
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

    clauses

module.exports = Parser