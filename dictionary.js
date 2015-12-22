// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = {
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
          object = model.self + "_" + model.count++;
          model.scope = object;
          parent = indirect != null ? indirect : scope;
          syntax = [];
          syntax.push(object + " = new " + model.Self + "(" + ref + ")");
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
