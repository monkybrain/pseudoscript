dictionary =

  adverbs:
    delay:
      pattern: /\b((in)|(after)|(wait))\s+\d+/g
    interval:
      pattern: /\b(every)\s+\d+/g
    at:
      pattern: /\bat\b/g

  units:
    time:
      words:
        milliseconds:
          patterns: [/\d+\s?((millisecond(s)?)|(ms))(\b|\d+)/g]
        seconds:
          patterns: [/\d+\s?((second(s)?)|(sec)|(s))(\b|\d+)/g]
        minutes:
          patterns: [/\d+\s?((minute(s)?)|(min)|(m))(\b|\d+)/g]
        hours:
          patterns: [/\d+\s?((hour(s)?)|(h))(\b|\d+)/g]
        days:
          patterns: [/\d+\s?((day(s)?)|(d))(\b|\d+)/g]
      order:
        interval: ['seconds', 'minutes', 'hours', 'days']
        specific: ['minutes', 'hours']
        # For ':' matching



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

module.exports = dictionary