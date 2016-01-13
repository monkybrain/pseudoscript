class Adverb

  constructor: (dict) ->
    @dict = dict

  test: (text) ->
    adverb = @find text
    if adverb?
      result = type: 'adverb', adverb: adverb
      if adverb is 'delay' or adverb is 'interval'
        result.time =  @interval text
      if adverb is 'at'
        result.time = @specific text
      return result

  find: (text) ->
    for entry, def of @dict.adverbs
      match = text.match def.pattern
      if match?
        return entry

  time2ms: (time) ->
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

  interval: (text) ->
    time = {}
    for entry, def of @dict.units.time.words
      for pattern in def.patterns
        matches = text.match pattern
        if matches?

          # Look for time defined in words (e.g. '2 minutes and 4 seconds')
          for match in matches
            unit = entry
            value = match.match(/\d+/g)[0]
            if time[unit]? then time[unit] += value else time[unit] = value

    if Object.keys(time).length is 0

      # Look for time defined with ':'
      pattern = /(\d+(:\d+)*)/g
      match = text.match pattern
      if match?
        string = match[0]
        segments = string.split(":").reverse()
        for segment, index in segments
          unit = @dict.units.time.order.interval[index]
          value = segment
          time[unit] = value

    if Object.keys(time).length is 0
      return null
    else
      return @time2ms time

  specific: (text) ->

    # TODO: FIX TIMEZONE PROBLEM!

    datetime = null

    # Check whether 12 or 24 hour format
    match = text.match /\b(pm)|(am)\b/g
    twentyfour = if match? then false else true

    # Separate time expression
    match = text.match /(\d+(:\d+)*)/g
    if match?
      time = {}
      string = match[0]
      segments = string.split(":").reverse()
      for segment, index in segments
        unit = @dict.units.time.order.specific[index]
        value = segment
        time[unit] = if value < 10 then "0#{value}" else value
      datetime = new Date().toISOString()
      datetime = datetime.slice 0, datetime.indexOf "T" + 1
      if not time.minutes?
        time.minutes = '00'
      if not time.seconds?
        time.seconds = '00'
      datetime = "#{datetime}T#{time.hours}:#{time.minutes}:#{time.seconds}"

    return datetime

module.exports = Adverb