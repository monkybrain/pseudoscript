// Generated by CoffeeScript 1.10.0
(function() {
  var Finder, Parser, error, log, tools;

  tools = require("monky-tools");

  log = tools.console.log;

  error = tools.console.error;

  Finder = (function() {
    function Finder(dictionary, map) {
      this.dict = dictionary;
      this.map = map;
    }

    Finder.prototype.verb = function(clause) {
      var definition, entry, match, ref;
      ref = this.dict.verbs;
      for (entry in ref) {
        definition = ref[entry];
        match = clause.match(entry);
        if (match != null) {
          return definition;
        }
      }
    };

    Finder.prototype.object = function(clause) {
      var key, match, object, ref;
      ref = this.map;
      for (key in ref) {
        object = ref[key];
        match = clause.match(object.word);
        if (match != null) {
          return object.word;
        }
      }
    };

    Finder.prototype.property = function(clause, object) {
      var key, match, obj, property, ref;
      ref = this.map;
      for (key in ref) {
        obj = ref[key];
        if (obj.word === object) {
          for (property in obj.properties) {
            match = clause.match(property);
            if (match != null) {
              return property;
            }
          }
        }
      }
    };

    Finder.prototype.value = function(clause) {
      var match, pattern, value, verb;
      verb = this.verb(clause);
      if (verb != null) {
        if (verb.value != null) {
          return verb.value;
        }
      }
      pattern = new RegExp("(to )|(by )");
      match = clause.match(pattern);
      if (match != null) {
        value = clause.slice(match.index);
        value = value.replace(match[0], "");
        value = value.split(" ")[0];
        return value;
      }
      pattern = /\d+ time(s)|( )/g;
      match = pattern.exec(clause);
      if (match != null) {
        value = clause.slice(match.index);
        value = value.replace("times", "");
        if (!isNaN(parseInt(value))) {
          value = parseInt(value);
        }
        return value;
      }
    };

    Finder.prototype.unit = function(clause) {
      var definition, entry, match, ref;
      ref = this.dict.units;
      for (entry in ref) {
        definition = ref[entry];
        match = clause.match(definition.pattern);
        if (match != null) {
          return entry;
        }
      }
    };

    Finder.prototype.reference = function(clause) {
      var end, indices, match, pattern, reference, start;
      pattern = /"|'/g;
      indices = [];
      while (true) {
        match = pattern.exec(clause);
        if (match != null) {
          indices.push(match.index);
        } else {
          break;
        }
      }
      if (indices.length > 0) {
        start = indices[0] + 1;
        end = indices[1];
        reference = clause.slice(start, end);
      }
      return reference;
    };

    return Finder;

  })();

  Parser = (function() {
    function Parser(dictionary, map) {
      this.dict = dictionary;
      this.map = map;
      this.find = new Finder(this.dict, this.map);
      this.scope = {
        verb: null,
        object: {
          "class": null,
          ref: null
        },
        indirect: {
          "class": null,
          ref: null
        },
        property: null
      };
    }

    Parser.prototype.separate = function(line) {
      var clauses, conjunctions;
      line = line.toLowerCase();
      conjunctions = /( and )|(, )/g;
      clauses = line.split(conjunctions);
      clauses = clauses.filter(function(clause) {
        if (clause == null) {
          return false;
        }
        return !clause.match(conjunctions);
      });
      return clauses;
    };

    Parser.prototype.parse = function(line) {
      var clause, clauses, i, len, object, property, reference, type, unit, value, verb;
      clauses = this.separate(line);
      clauses = clauses.map(function(clause) {
        return {
          text: clause
        };
      });
      for (i = 0, len = clauses.length; i < len; i++) {
        clause = clauses[i];

        /* VERB */
        verb = this.find.verb(clause.text);
        if (verb != null) {
          clause.type = 'verb phrase';
          this.scope.verb = clause.verb = verb.type;
          if (verb.property != null) {
            this.scope.property = clause.property = verb.property;
          }
          if (verb.value != null) {
            this.scope.value = clause.value = verb.value;
          }
        } else {
          clause.verb = this.scope.verb;
        }

        /* OBJECT - TYPE */
        type = this.find.object(clause.text);
        if (type != null) {
          object = {
            type: type
          };
          this.scope.object = clause.object = object;
        } else {
          clause.object = this.scope.object;
        }

        /* OBJECT - REFERENCE */
        reference = this.find.reference(clause.text);
        if (reference != null) {
          this.scope.object.ref = clause.object.ref = reference;
        } else {
          clause.object.ref = this.scope.object.ref;
        }

        /* PROPERTY */
        property = this.find.property(clause.text, this.scope.object.type);
        if (property != null) {
          this.scope.property = clause.property = property;
        } else {
          clause.property = this.scope.property;
        }

        /* VALUE */
        value = this.find.value(clause.text);
        if (value != null) {
          value = isNaN(parseFloat(value)) ? value : parseFloat(value);
          this.scope.value = clause.value = value;
        } else {
          clause.value = this.scope.value;
        }

        /* UNITS */
        if (typeof clause.value === 'number') {
          unit = this.find.unit(clause.text);
          if (unit != null) {
            this.scope.unit = clause.unit = unit;
          } else {
            clause.unit = this.scope.unit;
          }
        }
      }
      return clauses;
    };

    return Parser;

  })();

  module.exports = Parser;

}).call(this);
