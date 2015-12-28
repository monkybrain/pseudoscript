map = require "./js/map"
dict = require "./js/dictionary"

log = (info) ->
  console.log info

indent = (lines) ->
  processed = []
  for line in lines
    processed.push "  " + line
  processed

find =
  verb: (clause) ->
    for entry, definition of dict.verbs
      match = clause.match entry
      if match?
        return definition

  adverb: (sentence) ->
    for entry, definition of dict.adverbs
      match = sentence.match new RegExp(entry)
      if match?
        log match
        value = match.input.match /\d+/
        value = parseInt value[0]
        unit = match.input.match /(seconds )|(s )|(minutes )|(min )/
        unit = unit[0].trim()
        if unit is 'seconds' or unit is 's'
          value = value * 1000
        else if unit is 'minutes' or unit is 'm'
          value = value * 1000 * 60
        return type: 'delay', value: value

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

  adverb = find.adverb line

  sentence =
    main: clauses[0]
    sub: clauses[1...]
    adverb: adverb

construct =
  # TODO: Fix terrible naming! ('info' and 'newWord' especially!)
  set: (info) ->
    "#{info.object}.#{info.property} = #{info.value}"
  increase: (info) ->
    "#{info.object}.#{info.property} += #{info.value}"
  decrease: (info) ->
    "#{info.object}.#{info.property} -= #{info.value}"
  question: (info) ->
    "console.log #{info.object}.#{info.property}"
  conditional: (info) ->
    "if #{info.object}.#{info.property} is #{value}"


process = (input) ->

  # Add input as commented line
  code = []
  code.push "\n# #{input}"

  sentence = separate(input)

  # Main clause
  info = find.verb(sentence.main)
  if not info.object?
    info.object = find.object(sentence.main) # TODO: Figure out why toString() is/isn't needed?
  if not info.property?
    info.property = find.property(sentence.main, info.object)
  if not info.value?
    info.value = find.value(sentence.main, info.object)

  # Get syntax and construct CoffeeScript line
  lines = []
  if info.type is 'set'
    lines.push construct.set info
  if info.type is 'increase'
    lines.push construct.increase info
  if info.type is 'decrease'
    lines.push construct.decrease info
  if info.type is 'question'
    lines.push construct.question info
  if info.type is 'conditional'
    lines.push construct.conditional info

  # Subclauses
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

  # Process adverb
  if sentence.adverb?
    lines = indent(lines)
    lines.unshift "f = () ->"
    lines.push "setTimeout f, #{sentence.adverb.value}"

  code.push lines.join "\n"
  code.join "\n"

# RUN
###inputs = [
  # "turn on the light and set the timer to 30 minutes"
  # "turn on the light and increase the light's brightness to 50 and increase it again by 20"
  # "turn the light off please and set the timer to 20 minutes, okay?"
  # "turn on the bloody light and set the bleeding brightness to 45 you stupid home automation system!"
 "turn the light's brightness up to 40 would ya?"
]###

###for input in inputs
  log process input###


# input = "turn on the light please and set the brightness to 4"
# input = "if the light brightness is 20 then"
# input = "turn on the bloody light and set the bleeding brightness to 45 you pathetic excuse for a home automation system!"
input = "in 1 s turn on the light and set the brightness to 20"
log process input





