// Generated by CoffeeScript 1.10.0
(function() {
  var Parser, Parts, Scope, error, log, tools;

  tools = require("monky-tools");

  Parts = require("./parts/parts");

  Scope = require("./parts/scope");

  log = tools.console.log;

  error = tools.console.error;

  Parser = (function() {
    function Parser(modules) {
      this.modules = modules;
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

    Parser.prototype.process = function(line) {
      return line = line.toLowerCase();
    };

    Parser.prototype.segmentize = function(line) {
      var i, index, indices, j, keyword, len, pattern, ref, ref1, result, segments;
      indices = [];
      ref = Parts.keywords;
      for (i = 0, len = ref.length; i < len; i++) {
        keyword = ref[i];
        pattern = new RegExp(keyword, "g");
        while (true) {
          result = pattern.exec(line);
          if (result != null) {
            indices.push(result.index);
          } else {
            break;
          }
        }
      }
      segments = [];
      indices.sort(function(a, b) {
        return a > b;
      });
      for (index = j = 0, ref1 = indices.length; 0 <= ref1 ? j < ref1 : j > ref1; index = 0 <= ref1 ? ++j : --j) {
        if (indices[index + 1] == null) {
          console.log("got here");
          segments.push(line.slice(indices[index]));
          break;
        } else {
          segments.push(line.slice(indices[index], indices[index + 1]));
        }
      }
      return segments;
    };

    Parser.prototype.parse = function(line) {
      var i, len, ref, result, segments, verb;
      line = this.process(line);
      segments = [];
      console.log(this.segmentize(line));

      /* ADVERB */
      result = Parts.adverb.test(line);
      if (result != null) {
        segments.push(result);
      }

      /* VERBS */
      ref = Parts.verbs;
      for (i = 0, len = ref.length; i < len; i++) {
        verb = ref[i];
        result = verb.test(line);
        if (result != null) {
          Scope.type = 'verb';
          Scope.subtype = verb.lexical.base;
          segments.push(result);
        }
      }
      return segments;
    };

    return Parser;

  })();

  module.exports = Parser;

}).call(this);
