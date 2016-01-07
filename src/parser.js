// Generated by CoffeeScript 1.10.0
(function() {
  var Finder, Parser, error, log, tools;

  tools = require("monky-tools");

  log = tools.console.log;

  error = tools.console.error;

  Finder = (function() {
    Finder.prototype.capitalize = function(string) {
      return string = string[0].toUpperCase() + string.slice(1);
    };

    function Finder(dictionary, map) {
      this.dict = dictionary;
      this.map = map;
    }

    Finder.prototype.adverb = function(clause) {
      var definition, entry, match, ref1;
      ref1 = this.dict.adverbs;
      for (entry in ref1) {
        definition = ref1[entry];
        match = clause.match(new RegExp(entry));
        if (match != null) {
          return definition;
        }
      }
    };

    Finder.prototype.event = function(clause) {
      var k, key, match, object, ref, ref1, ref2, v, value;
      match = clause.match(new RegExp(this.dict.event));
      if (match != null) {
        object = {};
        ref = this.reference(clause);
        if (ref != null) {
          object.ref = ref;
        }
        if (ref == null) {
          object.type = this.capitalize(this.object(clause));
        }
        ref1 = this.map;
        for (key in ref1) {
          value = ref1[key];
          if (value.events != null) {
            ref2 = value.events;
            for (k in ref2) {
              v = ref2[k];
              match = clause.match(k);
              if (match != null) {
                return {
                  object: object,
                  event: v.event
                };
              }
            }
          }
        }
      }
    };

    Finder.prototype.verb = function(clause) {
      var definition, entry, match, ref1;
      ref1 = this.dict.verbs;
      for (entry in ref1) {
        definition = ref1[entry];
        match = clause.match(new RegExp(entry));
        if (match != null) {
          return definition;
        }
      }
    };

    Finder.prototype.object = function(clause) {
      var key, match, object, ref1;
      ref1 = this.map;
      for (key in ref1) {
        object = ref1[key];
        match = clause.match(object.word);
        if (match != null) {
          return object.word;
        }
      }
    };

    Finder.prototype.property = function(clause, object) {
      var key, match, obj, property, ref1;
      ref1 = this.map;
      for (key in ref1) {
        obj = ref1[key];
        for (property in obj.properties) {
          match = clause.match(property);
          if (match != null) {
            return property;
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

    Finder.prototype.conditional = function(clause) {
      var end, k, k2, lefthand, match, pattern, ref1, result, results, righthand, start, v, v2;
      ref1 = this.dict.conditionals;
      results = [];
      for (k in ref1) {
        v = ref1[k];
        pattern = new RegExp(k);
        match = clause.match(pattern);
        if (match != null) {
          result = {
            type: v.type
          };
          if (result.type === 'if') {
            results.push((function() {
              var ref2, results1;
              ref2 = this.dict.comparisons;
              results1 = [];
              for (k2 in ref2) {
                v2 = ref2[k2];
                pattern = new RegExp(k2);
                match = clause.match(pattern);
                if (match != null) {
                  result.test = v2.type;
                  pattern = /if .*? is/;
                  if (match != null) {
                    start = clause.indexOf("if") + "if".length;
                    end = clause.indexOf("is");
                    lefthand = clause.slice(start, end).trim();
                    start = clause.indexOf("than") + "than".length;
                    righthand = clause.slice(start).trim();
                    if (!isNaN(lefthand)) {
                      lefthand = parseFloat(lefthand);
                    }
                    if (!isNaN(righthand)) {
                      righthand = parseFloat(righthand);
                    }
                    result.lefthand = lefthand;
                    result.righthand = righthand;
                    results1.push(result);
                  } else {
                    results1.push(void 0);
                  }
                } else {
                  results1.push(void 0);
                }
              }
              return results1;
            }).call(this));
          } else {
            results.push(void 0);
          }
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Finder.prototype.unit = function(clause) {
      var definition, entry, match, ref1;
      ref1 = this.dict.units;
      for (entry in ref1) {
        definition = ref1[entry];
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
          type: null,
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
      var adverb, clause, clauses, conditional, event, i, len, match, object, property, ref, type, unit, value, verb;
      clauses = this.separate(line);
      clauses = clauses.map(function(clause) {
        return {
          text: clause
        };
      });
      for (i = 0, len = clauses.length; i < len; i++) {
        clause = clauses[i];

        /* ADVERB */
        adverb = this.find.adverb(clause.text);
        if (adverb != null) {
          clause.type = 'adverbial phrase';
          clause.adverb = adverb.type;
          match = clause.adverb.match(/(delay)|(interval)/g);
          if (match != null) {
            clause.value = this.find.value(clause.text);
            clause.unit = this.find.unit(clause.text);
          }
          continue;
        }

        /* EVENT */
        event = this.find.event(clause.text);
        if (event != null) {
          clause.type = 'event phrase';
          clause.object = event.object;
          clause.event = event.event;
          continue;
        }

        /* CONDITIONALS */
        conditional = this.find.conditional(clause.text);
        if (conditional != null) {
          console.log(conditional);
          clause.type = 'conditional phrase';
          clause.conditional = conditional;
          continue;
        }

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

        /* OBJECT - REFERENCE */
        ref = this.find.reference(clause.text);
        if (ref != null) {
          object = {
            ref: ref
          };
          this.scope.object = clause.object = object;
        } else {
          clause.object = this.scope.object;
        }

        /* OBJECT - TYPE */
        type = this.find.object(clause.text);
        if (type != null) {
          if (object != null) {
            object.type = type;
          } else {
            object = {
              type: type
            };
          }
          this.scope.object = clause.object = object;
        } else {
          clause.object = this.scope.object;
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
