// Generated by CoffeeScript 1.10.0

/* generated by pseudoscript 0.1 */

(function() {
  var Light, Room, Util;

  Util = require('../src/core/util');

  Light = require('../src/modules/light');

  Room = require('../src/modules/room');

  new Light('Hue 1');

  setInterval(function() {
    return Light.select('Hue 1').then(function() {
      return Light.set({
        hue: Util.random({
          min: 0,
          max: 65535
        }),
        transitionTime: 4,
        brightness: Util.random({
          min: 0,
          max: 254
        })
      });
    });
  }, 2 * 1000);

  new Light('Hue 2');

  Light.select('Hue 2').then(function() {
    return Light.set({
      saturation: 0,
      brightness: 250
    });
  });

  setInterval(function() {
    Light.select('Hue 2').then(function() {
      return Light.set({
        brightness: 250,
        transitionTime: 0
      });
    });
    return setTimeout(function() {
      return Light.select('Hue 2').then(function() {
        return Light.set({
          brightness: 0,
          transitionTime: 0
        });
      });
    }, 0.1 * 1000);
  }, 0.2 * 1000);

}).call(this);
