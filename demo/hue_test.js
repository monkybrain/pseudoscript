// Generated by CoffeeScript 1.10.0

/* generated by pseudoscript 0.1 */

(function() {
  var Light;

  Light = require("../src/modules/light");

  new Light('Hue 1');

  setTimeout(function() {
    return console.log(Light.select('Hue 1').set());
  }, 1000);

}).call(this);
