// Generated by CoffeeScript 1.10.0
(function() {
  var Light, Module,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Module = require("./module");

  Light = (function(superClass) {
    extend(Light, superClass);

    function Light() {
      return Light.__super__.constructor.apply(this, arguments);
    }

    Light.self = 'Light';

    Light.lexical = {
      base: 'light'
    };

    Light.members = [];

    Light.properties = {
      'on': {
        type: 'boolean',
        set: true,
        "default": true
      },
      'color': {
        type: 'string',
        set: true,
        "default": 'white'
      },
      'brightness': {
        type: 'number',
        set: true,
        "default": 100
      }
    };

    return Light;

  })(Module);

  module.exports = Light;

}).call(this);
