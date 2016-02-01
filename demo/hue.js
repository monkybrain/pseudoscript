// Generated by CoffeeScript 1.10.0

/* generated by pseudoscript 0.1 */

(function() {
  var Light, Room, Util;

  Util = require('../src/core/util');

  Light = require('../src/modules/light');

  Room = require('../src/modules/room');

  new Light('Hue 1');

  Light.select('Hue 1').then(function() {
    return Light.set({
      hue: 5000,
      brightness: 100,
      saturation: 100
    });
  });

  Light.select('Hue 1').then(function() {
    return Light.get(['hue', 'saturation']);
  }).then(function(operands) {
    return Util.math.multiply([operands.hue, operands.saturation]);
  }).then(function(response) {
    return console.log(response);
  });

}).call(this);
