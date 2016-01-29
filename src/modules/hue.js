// Generated by CoffeeScript 1.10.0
(function() {
  var Hue, Promise, client, huejay, lights, ready, util;

  huejay = require("huejay");

  util = require("util");

  Promise = require("promise");

  client = new huejay.Client({
    host: '192.168.0.198',
    username: '729c9abad20352b1a8a56cc2bf2a0b6'
  });

  ready = false;

  Hue = (function() {
    function Hue() {}

    Hue.ready = function() {
      return new Promise(function(resolve, reject) {
        var run;
        run = function() {
          if (ready) {
            return resolve('Hue ready');
          } else {
            return setTimeout(function() {
              return run();
            }, 5);
          }
        };
        return run();
      });
    };

    Hue.lights = [];

    Hue.light = {
      set: function(id) {
        return console.log(id);
      }
    };

    return Hue;

  })();


  /* INIT */


  /*Hue.lights = [
    light: attributes: {attributes: {name: 'Hue 1'}},
    light: attributes: {attributes: {name: 'Hue 2'}}]
  
  ready = true
   */

  lights = client.lights.getAll().then(function(lights) {
    Hue.lights = lights;
    return ready = true;
  }, function(error) {
    return console.error(error);
  });

  module.exports = Hue;

}).call(this);
