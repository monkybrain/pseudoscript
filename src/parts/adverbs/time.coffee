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
        pattern = unit
        if expression.match(pattern)?
          return k

  @getTime: (text) ->

    ###
    # Assemble pattern: number + unit (e.g. '1 minute', '37 s')
    units = Util.regex.group @getUnits()
    # pattern = new RegExp "(\\d+\\s)" + units, "g"
    pattern = new RegExp "\\d+" + units, "g"
    ###

    units = Util.regex.group @getUnits()
    # pattern = "\\d+\\s*" + units + "((\\d+)|(\\b))+"
    pattern = "\\d+\\s*" + units
    pattern = new RegExp pattern, "g"
    console.log pattern


    # Find time expressions
    results = []
    loop
      result = pattern.exec text
      console.log text
      console.log result
      if result?
        [all, value, unit] = result
        results.push [value, unit]
      else break

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
