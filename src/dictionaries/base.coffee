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

    'get':
      type: 'get'

    # DO
    'blink':
      type: 'do'
      action: 'blink'
      value: 3

    'send':
      type: 'send'

    # CREATE
    '(create)|(add)|(connect)':
      type: 'create'

    # LOG
    '(show)|(show me)|(display)':
      type: 'log'

    # INCREASE/DECREASE
    'increase .*? by':
      type: 'increase'
    'turn .*? up by':
      type: 'increase'
    'decrease .*? by':
      type: 'decrease'
    'turn .*? down by':
      type: 'decrease'

  adverbs:
    '^(in)|(after)|(wait) \\d+':
      type: 'delay'
    '^(every) \\d+':
      type: 'interval'

  event: '(when)|(upon).*?'

  conditionals:
    '\\b((if)|(in case))\\b':
      type: 'if'

  comparisons:
    '\\bis ((equal)|(the same as)) to\\b':
      type: '=='
    '\\bis ((greater)|(larger)|(bigger)|(higher)) than\\b':
      type: '>'
    '\\bis ((smaller)|(less)|(lower)) than\\b':
      type: '<'

  units:
    milliseconds:
      pattern: /\d+\s+(milliseconds)|(ms)\b/g
    seconds:
      pattern: /\d+\s+(seconds)|(sec)|(s)\b/g
    minutes:
      pattern: /\d+\s+(minutes)|(min)|(m)\b/g
    hours:
      pattern: /\d+\s+(hours)|(h)\b/g
    days:
      pattern: /\d+\s+(days)|(d)\b/g



module.exports = dictionary