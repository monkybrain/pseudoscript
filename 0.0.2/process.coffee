map = require "./js/map"
dict = require "./js/dictionary"

log = (info) ->
  console.log info

# Input string
input = "turn on the light, set the brightness to 45 and set the timer to 20"

separate = (line) ->

  # Define separators and generate regular expression
  separators = ["and", ","]
  pattern = new RegExp(separators.join "|")

  # Split according to regex
  clauses = input.split pattern
  # Trim
  clauses = clauses.map (clause) ->
    clause.trim()

  sentence =
    main: clauses[0]
    sub: clauses.slice 1

find =
  verb: (clause) ->
    for entry, word of dict.verbs
      match = clause.match entry
      if match?
        return word

  object: (clause) ->
    for key, object of map
      match = clause.match object.word
      if match?
        return object.word.toString()

  property: (clause, object) ->
    for key, obj of map
      if obj.word is object
        for property of obj.properties
          match = clause.match property
          if match?
            return property

  value: (clause, object) ->
    match = clause.match "to"
    if match?
      value = clause.slice match.index
      value = value.replace "to ", ""
      return value

construct =
  set: (info) ->
    syntax = "#{info.object}.#{info.property} = #{info.value}"

process = (input) ->

  # Add input as commented line
  code = []
  code.push "# #{input}"

  sentence = separate(input)

  # Main clause
  info = find.verb(sentence.main)
  if not info.object?
    info.object = find.object(sentence.main).toString() # TODO: Figure out why toString() is needed?
  if not info.property?
    find.property(sentence.main, info.object)
  ###if not info.value?
    find.value(sentence.main, info.object)###

  lines = []
  if info.type is 'set'
    lines.push construct.set info

  for clause in sentence.sub
    property = find.property clause, info.object
    if property?
      info.property = property
    value = find.value clause, info.object
    if value?
      info.value = value
    if info.type is 'set'
      lines.push construct.set info

  code.push lines.join "\n"
  code.join "\n"

# RUN
log process input





