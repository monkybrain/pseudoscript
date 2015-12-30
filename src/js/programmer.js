// Generated by CoffeeScript 1.10.0
(function() {
  var Programmer;

  Programmer = (function() {
    function Programmer(map) {
      this.map = map;
    }

    Programmer.prototype.capitalize = function(string) {
      return string = string[0].toUpperCase() + string.slice(1);
    };

    Programmer.prototype.indent = function(string) {
      return "  " + string;
    };

    Programmer.prototype.process = function(script) {
      var i, len, object, operation, property, ref, syntax, type, value, verb;
      syntax = [];
      for (i = 0, len = script.length; i < len; i++) {
        operation = script[i];
        verb = operation.verb;
        ref = operation.object.ref;
        type = this.capitalize(operation.object.type);
        object = operation.object;
        property = operation.property;
        value = isNaN(operation.value) ? "'" + operation.value + "'" : operation.value;
        if (verb === 'create') {
          syntax.push("\n  # Create " + type + " called '" + ref + "'");
          syntax.push("  new " + type + "('" + ref + "', photon)\n");
        }
        if (verb === 'set') {
          syntax.push("\n  # Set the property '" + property + "' of '" + ref + "' to " + value);
          syntax.push("  " + type + ".get('" + ref + "').set('" + property + "', " + value + ")");
          syntax.push("\n.then () ->");
        }
        if (verb === 'increase') {
          syntax.push("\n# Increasing the property '" + property + "' of '" + ref + "' by " + value);
          syntax.push("  " + type + ".get('" + ref + "').inc('" + property + "', " + value + ").then () ->");
          syntax.push("\n.then () ->");
        }
      }
      return syntax.join("\n");
    };

    Programmer.prototype.wrap = function(code) {
      var output;
      output = [];
      output.push("map = require './map'");
      output.push("Room = map.Room");
      output.push("Light = map.Light\n");
      output.push("Photon = require './photon'");
      output.push("photon = new Photon()\n");
      output.push("console.log '# Running script #'");
      output.push("photon.connect()\n.then () ->");
      output.push(code);
      output.push(this.indent("console.log '# End of script #'"));
      return output.join("\n");
    };

    return Programmer;

  })();

  module.exports = Programmer;

}).call(this);