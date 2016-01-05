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

    # DO
    'blink':
      type: 'do'
      action: 'blink'
      value: 3

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
    '^(in)|(after) \\d+':
      type: 'delay'
    '^(every) \\d+':
      type: 'interval'

  events:
    'when .*?':
      # TODO: MAKE DYNAMIC!
      event:
        'pushed'

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