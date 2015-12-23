map = require "./js/map"
dict = require "./js/dictionary"

log = (info) ->
  console.log info

separate = (line) ->

  # Remove conjunctions and punctuation
  ignore = new RegExp "(and)|,|!", "g"
  line = line.replace ignore, " "

  # Define separators and generate regular expression
  separators = Object.keys(dict.verbs).map (separator) ->
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
    # Find prepositions
    pattern = new RegExp("(to )|(by ) ")
    match = clause.match pattern
    if match?
      value = clause.slice match.index
      value = value.replace match[0], ""
      value = value.split(" ")[0]
      return value

construct =
  # TODO: Fix terrible object names! (info especially!)
  set: (info) ->
    syntax = "#{info.object}.#{info.property} = #{info.value}"
  increase: (info) ->
    syntax = "#{info.object}.#{info.property} += #{info.value}"
  decrease: (info) ->
    syntax = "#{info.object}.#{info.property} -= #{info.value}"


process = (input) ->

  # Add input as commented line
  code = []
  code.push "\n# #{input}"

  sentence = separate(input)

  # Main clause
  info = find.verb(sentence.main)
  if not info.object?
    info.object = find.object(sentence.main) # TODO: Figure out why toString() is needed?
  if not info.property?
    info.property = find.property(sentence.main, info.object)
  if not info.value?
    info.value = find.value(sentence.main, info.object)

  lines = []
  if info.type is 'set'
    lines.push construct.set info
  if info.type is 'increase'
    lines.push construct.increase info
  if info.type is 'decrease'
    lines.push construct.decrease info

  for clause in sentence.sub
    newWord = find.verb(clause)
    info.type = newWord.type

    # Process property
    if newWord.property?
      info.property = newWord.property
    property = find.property clause, info.object
    if property?
      info.property = property

    # Process value
    if newWord.value? then info.value = newWord.property
    value = find.value clause, info.object
    if value?
      info.value = value
    if info.type is 'set'
      lines.push construct.set info
    if info.type is 'increase'
      lines.push construct.increase info
    if info.type is 'decrease'
      lines.push construct.decrease info

  code.push lines.join "\n"
  code.join "\n"

# RUN
inputs = [
  # "turn on the light and set the timer to 30 minutes"
  # "turn on the light and increase the light's brightness to 50 and increase it again by 20"
  # "turn the light off please and set the timer to 20 minutes, okay?"
  # "turn on the bloody light and set the bleeding brightness to 45 you stupid home automation system!"
 "turn the light's brightness up to 40 would ya?"
]

for input in inputs
  log process input





