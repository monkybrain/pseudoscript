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

module.exports = dictionary