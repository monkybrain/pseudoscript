// Generated by CoffeeScript 1.10.0
(function() {
  var dictionary;

  dictionary = {
    verbs: {
      '(turn on)|(turn .*? on)': {
        property: "on",
        value: true,
        type: 'set'
      },
      '(turn off)|(turn .*? off)': {
        property: "on",
        value: false,
        type: 'set'
      },
      'set .*? to': {
        type: 'set'
      },
      'increase .*? to': {
        type: 'set'
      },
      'decrease .*? to': {
        type: 'set'
      },
      'turn .*? up to': {
        type: 'set'
      },
      'turn .*? down to': {
        type: 'set'
      },
      'create': {
        type: 'create'
      },
      'increase .*? by': {
        type: 'increase'
      },
      'turn .*? up by': {
        type: 'increase'
      },
      'decrease .*? by': {
        type: 'decrease'
      },
      'turn .*? down by': {
        type: 'decrease'
      },
      'is .*? ?': {
        type: 'question'
      },
      'what .*? \?': {
        type: 'question'
      },
      'if .*? (then)|(,)': {
        type: 'conditional'
      }
    }
  };

  module.exports = dictionary;

}).call(this);
