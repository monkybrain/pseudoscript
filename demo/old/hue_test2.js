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
      hue: 50000,
      brightness: 250,
      saturation: 250
    });
  });

  setInterval(function() {
    Light.select('Hue 1').then(function() {
      return Light.set({
        hue: Util.random({
          min: 0,
          max: 65535
        })
      });
    });
    return Light.select('Hue 1').then(function() {
      return Light.set({
        transitionTime: 5
      });
    });
  }, 5 * 1000);

}).call(this);
