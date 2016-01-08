tools = require "monky-tools"
Finder = require "./finder"
Parts = require "./parts/parts"

log = tools.console.log
error = tools.console.error

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
      result = Parts.adverb.test clause.text
      if result?
        # console.log result
        continue
      else
        continue

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
      result = @find.conditional clause.text
      if result?
        text = clause.text
        clause.type = 'conditional phrase'
        clause.subtype = result.type
        if result.type is 'if'
          for k2, v2 of @dict.comparisons
            pattern = new RegExp k2
            match = text.match pattern
            if match?
              clause.test = v2.type
              # Find values
              pattern = /if .*? is/
              if match?
                # Get left hand expression
                start = text.indexOf("if") + "if".length
                end = text.indexOf "is"
                lefthand = text.slice(start, end).trim()
                # Get right hand expression
                start = text.indexOf("than") + "than".length
                righthand = text.slice(start).trim()
                if not isNaN lefthand
                  lefthand = parseFloat lefthand
                if not isNaN righthand
                  righthand = parseFloat righthand
                clause.lefthand = lefthand
                clause.righthand = righthand
                console.log clause
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