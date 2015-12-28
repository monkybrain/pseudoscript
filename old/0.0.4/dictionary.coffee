dictionary =

  verbs:
  # SET
    '(turn on)|(turn .*? on)':
      property: "on"
      value: true
      type: 'set'
    '(turn off)|(turn .*? off)':
      property: "on"
      value: false
      type: 'set'
    'set .*? to':
      type: 'set'
    'increase .*? to':
      type: 'set'
    'decrease .*? to':
      type: 'set'
    'turn .*? up to':
      type: 'set'
    'turn .*? down to':
      type: 'set'
  # CREATE
    'create':
      type: 'create'
  # INCREASE/DECREASE
    'increase .*? by':
      type: 'increase'
    'turn .*? up by':
      type: 'increase'
    'decrease .*? by':
      type: 'decrease'
    'turn .*? down by':
      type: 'decrease'
  # QUESTIONS
    'is .*? ?':
      type: 'question'
    'what .*? \?':
      type: 'question'
  # CONDITIONALS
    'if .*? (then)|(,)':
      type: 'conditional'

  adverbs:
#    '^(in)|(after) \d+ (seconds)|(s)|(minutes)|(min)|(milliseconds)|(ms)|(hours)|(h)':
#      type: 'delay'
    'in \d+ s':
      type: 'delay'

  timeUnits:
    milliseconds:
      pattern: /(milliseconds)|(ms) /
      process: (time) ->
        time
    seconds:
      pattern: /(seconds)|(s) /
      process: (time) ->
        time * 1000
    minutes:
      pattern: /(minutes)|(min) /
      process: (time) ->
        time * 1000 * 60
    hours:
      pattern: /(hours)|(h) /
      process: (time) ->
        time * 1000 * 60 * 60
    days:
      pattern: /days /
      process: (time) ->
        time * 1000 * 60 * 60 * 24




module.exports = dictionary