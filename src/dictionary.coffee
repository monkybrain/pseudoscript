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
    '(create)|(add)':
      type: 'create'
    'add':
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
  questions:
    'is .*? ?':
      type: 'question'
    'what .*? \?':
      type: 'question'
  conditionals:
  # CONDITIONALS
    'if .*? (then)|(,)':
      type: 'conditional'

  adverbs:
#    '^(in)|(after) \d+ (seconds)|(s)|(minutes)|(min)|(milliseconds)|(ms)|(hours)|(h)':
#      type: 'delay'
    'in \d+ s':
      type: 'delay'

  units:
    milliseconds:
      pattern: /\d+\s+(milliseconds)|(ms)\b/g
    seconds:
      pattern: /\d+\s+(seconds)|(sec)\b/g
    minutes:
      pattern: /\d+\s+(minutes)|(min)|(m)\b/g
    hours:
      pattern: /\d+\s+(hours)|(h)\b/g
    days:
      pattern: /\d+\s+(days)|(d)\b/g



module.exports = dictionary