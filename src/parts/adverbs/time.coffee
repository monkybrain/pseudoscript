Adverb = require "./adverb"
Util = require "../../util"
dict = require("../../dictionaries/dictionary").adverbs

class Time extends Adverb

  @types: dict.time.types

  @units: dict.time.units

  @getPrepositions: () ->
    prepositions = []
    for k, v of @types
      for preposition in v.prepositions
        prepositions.push preposition
    prepositions

  @getType: (preposition) ->
    for k, v of @types
      for p in v.prepositions
        if preposition is p
          return k

  @getUnits: () ->
    units = []
    for k, v of @units
      for unit in v
        units.push unit
    units

  @getUnit: (expression) ->
    for k, v of @units
      for unit in v
        pattern = Util.regex.bound unit
        if expression.match(pattern)?
          return k

  @getTime: (text) ->

    # Assemble pattern: number + unit (e.g. '1 minute', '37 s')
    # FIXME: \s space adding hack!
    units = Util.regex.group @getUnits()
    pattern = new RegExp "\\d+\\s+?\\b" + units + "\\b", "g"

    # Find time expressions
    results = []
    loop
      result = pattern.exec text
      if result?
        results.push result[0]
      else break

    # Parse expressions
    expressions = []
    for result in results

      # Find value
      pattern = /\b\d+\b/g
      value = pattern.exec(result)[0]

      # Find unit
      pattern = new RegExp "\\b" + units + "\\b", "g"
      unit = @getUnit pattern.exec(result)[0]

      # Assemble time object
      time = {}
      time[unit] = value

      # Push time object to array
      expressions.push time

    # DEBUG: Write to console
    console.log expressions

    # Converted to milliseconds and return
    return @time2ms time

  @test: (text) ->

    # Assemble regex pattern from prepositions
    pattern = Util.regex.group @getPrepositions()
    pattern = Util.regex.bound pattern

    # Find preposition
    match = text.match pattern
    if match?
      preposition = match[0]

    # Get type of adverb by preposition
    type = @getType preposition

    # Get time (in milliseconds)
    time = @getTime text

    return type: type, time: time

  @time2ms: (time) ->
    milliseconds = 0
    if time.days?
      milliseconds += time.days * 1000 * 60 * 60 * 24
    if time.hours?
      milliseconds += time.hours * 1000 * 60 * 60
    if time.minutes?
      milliseconds += time.minutes * 1000 * 60
    if time.seconds?
      milliseconds += time.seconds * 1000
    if time.milliseconds?
      milliseconds += time.milliseconds
    milliseconds

# str = "After 7 days 4 h 2 min 45 seconds"
str = "Every 2m45s"
console.log Time.test(str.toLowerCase())

module.exports = Time
