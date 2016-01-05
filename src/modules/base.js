// Generated by CoffeeScript 1.10.0
(function() {
  var Button, Light, Objekt, Promise, Room, objects,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Promise = require("promise");

  Objekt = (function() {
    Objekt.word = 'object';

    Objekt.members = [];

    Objekt.scope = null;

    Objekt.index = 0;

    function Objekt(ref, photon) {
      if (ref != null) {
        this.ref = ref;
      } else {
        this.ref = this.constructor.word + this.constructor.index;
      }
      if (photon != null) {
        this.photon = photon;
      }
      this.children = [];
      this.constructor.members.push(this);
      this.constructor.index++;
      this.constructor.scope = this.ref;
    }

    Objekt.prototype.add = function(object) {
      return this.children.push(object.ref);
    };

    Objekt.prototype["do"] = function(action, times) {
      console.log(("Performing action '" + action + "' " + times + " time") + (times !== 1 ? "s" : ""));
      return this.photon["do"](action, times).then(function(result) {}, function(err) {
        return console.error(err);
      });
    };

    Objekt.prototype.set = function(property, value) {
      var found, key;
      console.log("Setting property '" + property + "' of '" + this.ref + "' to " + value);
      for (key in this.properties) {
        if (property === key) {
          found = true;
          break;
        }
      }
      if (found == null) {
        console.error("Invalid property");
      } else {
        if (typeof value === typeof this.properties[property]) {
          this.properties[property] = value;
        } else {
          console.error("Invalid value");
        }
      }
      if (this.photon) {
        return this.photon.set(property, value).then(function(result) {}, function(err) {
          return console.error(err);
        });
      }
    };

    Objekt.prototype.inc = function(property, value) {
      this.properties[property] += value;
      return this.set(property, this.properties[property]);
    };

    Objekt.prototype.dec = function(property, value) {
      this.properties[property] -= value;
      return this.set(property, this.properties[property]);
    };

    Objekt.prototype.alreadyUsing = function(ref) {
      return indexOf.call(this.constructor.members, ref) >= 0;
    };

    Objekt.get = function(ref) {
      var i, len, member, ref1;
      if (ref == null) {
        ref = this.scope;
      }
      ref1 = this.members;
      for (i = 0, len = ref1.length; i < len; i++) {
        member = ref1[i];
        if (ref === member.ref) {
          return member;
        }
      }
    };

    Objekt.prototype.on = function(event, callback) {
      return this.photon.on(event, callback);
    };

    return Objekt;

  })();

  Light = (function(superClass) {
    extend(Light, superClass);

    Light.word = 'light';

    Light.properties = {
      'on': true,
      'brightness': 5,
      'timer': 10,
      'color': 'white'
    };

    function Light(ref, photon) {
      Light.__super__.constructor.call(this, ref, photon);
      this.properties = Light.properties;
    }

    return Light;

  })(Objekt);

  Room = (function(superClass) {
    extend(Room, superClass);

    Room.word = 'room';

    Room.events = {
      'dark': {
        event: 'dark'
      },
      'light': {
        event: 'light'
      }
    };

    function Room(ref, photon) {
      Room.__super__.constructor.call(this, ref, photon);
      this.events = Room.events;
    }

    return Room;

  })(Objekt);

  Button = (function(superClass) {
    extend(Button, superClass);

    Button.word = 'button';

    Button.events = {
      '\\b((push)|(pushed)|(pushes))\\b': {
        event: 'pushed'
      }
    };

    Button.properties = {
      'active': true
    };

    function Button(ref, photon) {
      Button.__super__.constructor.call(this, ref, photon);
      this.events = Button.events;
      this.properties = Button.properties;
    }

    return Button;

  })(Objekt);

  objects = {
    Objekt: Objekt,
    Light: Light,
    Room: Room,
    Button: Button
  };

  module.exports = objects;

}).call(this);
