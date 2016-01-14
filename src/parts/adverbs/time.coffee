Adverb = require "./adverb"
Util = require "../../../core/util"
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

    # Match number + unit (e.g. '1 minute', '37s')
    units = @getUnits()
    results = []
    for unit in units
      # Pattern for matching number + unit
      pattern = "(\\d+)(\\s+)?(#{unit})((\\d+)|(\\b)|(\\s+))"
      match = text.match pattern
      if match?

        # Deconstruct match
        [whole, value, whitespace, unit] = match

        # Push 'value' and 'unit' to array (while discarding 'whole' & 'whitespace')
        results.push [value, unit]

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

      return type: 'adverb', adverb: type, time: time

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

  @syntax: (phrase) ->
    {adverb: adverb, time: time} = phrase
    if adverb is 'delay'
      open = ["# Setting timeout to #{time} seconds", "setTimeout () ->\n"]
      close = [", (#{time}*1000)\n"]
    if adverb is 'interval'
      open = ["# Setting interval to #{time} seconds", "setInterval () ->\n"]
      close = [", (#{time}*1000)\n"]
    return [open, close]

module.exports = Time
