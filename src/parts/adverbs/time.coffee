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
        pattern = new RegExp "\\b#{unit}\\b"
        if expression.match(pattern)?
          return k

  @getTime: (text) ->

    units = @getUnits()
    results = []
    for unit in units
      pattern = "(\\d+)(\\s+)?(#{unit})((\\d+)|(\\b)|(\\s+))"
      match = text.match pattern
      if match?
        # Deconstruct match
        [whole, value, whitespace, unit] = match
        # Push 'value' and 'unit' to array (while discarding 'whole' & 'whitespace')
        results.push [value, unit]
    console.log results

    for result in results
      console.log @getUnit result[1]

    ###
    # Assemble pattern: number + unit (e.g. '1 minute', '37s')
    units = Util.regex.group @getUnits()
    pattern = new RegExp "\\d+(\\s+)?(" + units + ")", "g"

    console.log pattern

    # Find time expressions
    results = []
    loop
      result = pattern.exec text
      if result?

        console.log result

        # Get value (i.e. find digits)
        matches = result[0].match /\d+/g
        value = matches[0]

        # Get unit
        matches = result[0].match new RegExp units + "(\\b)|(\\s)", "g"
        for match in matches
          if match isnt ''
            unit = match

        results.push [value, unit]
      else break

    ###

    ###
    # Parse time expressions
    time = {}
    for result in results

      # Deconstruct result
      [value, unit] = result

      # Convert string value to float
      value = parseFloat value

      # Get unit
      unit = @getUnit unit

      # If unit already used -> add new value, else -> create new key
      time[unit] = if time[unit]? then time[unit] += value else value

    # Convert to seconds and return
    return @time2sec time

    ###

  @test: (text) ->

    # Assemble regex pattern from prepositions
    pattern = Util.regex.bound Util.regex.group @getPrepositions()

    # Find preposition
    match = text.match pattern
    if match?

      preposition = match[0]

      # Get type of adverb by preposition
      type = @getType preposition

      # Get time (in milliseconds)
      time = @getTime text

      return type: type, time: time

  @time2sec: (time) ->
    seconds = 0
    if time.days?
      seconds += time.days * 60 * 60 * 24
    if time.hours?
      seconds += time.hours * 60 * 60
    if time.minutes?
      seconds += time.minutes * 60
    if time.seconds?
      seconds += time.seconds
    if time.milliseconds?
      seconds += time.milliseconds / 1000
    seconds

module.exports = Time
