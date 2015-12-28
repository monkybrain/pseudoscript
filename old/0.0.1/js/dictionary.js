// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = {
    types: {
      questions: {
        number: {
          patterns: [/how many.*?/],
          syntax: function(claas, members) {
            return "console.log question";
          }
        }
      }
    },
    prepositions: {
      to: {
        patterns: ["to"]
      }
    },
    verbs: {
      create: {
        patterns: ["let there be", "create", "add"],
        syntax: function(scope, model, ref, indirect) {
          var object, parent, syntax;
          object = model.self + "s[" + model.count++ + "]";
          model.scope = object;
          parent = indirect != null ? indirect : scope;
          syntax = [];
          syntax.push(model.self + "s.push new " + model.Self + "(" + ref + ")");
          syntax.push(parent + ".add " + object);
          return syntax.join("\n");
        }
      }
    },
    adverbs: {
      scope: {
        pattern: /in that/,
        syntax: function(object) {
          return object.Self + ".scope";
        }
      }
    },
    ignore: ['another', 'a', 'an', 'yet', 'the']
  };

}).call(this);
