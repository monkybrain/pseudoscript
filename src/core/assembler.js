// Generated by CoffeeScript 1.10.0
(function() {
  var Assembler, adverbs, verbs,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  verbs = require("./../parts/verbs/verbs");

  adverbs = require("./../parts/adverbs/adverbs");

  Assembler = (function() {
    function Assembler() {}

    Assembler.indent = {
      interval: 2,
      level: 0,
      inc: function() {
        return this.level += 2;
      },
      dec: function() {
        return this.level -= 2;
      },
      set: function(level) {
        return this.level = level;
      },
      exec: function(syntax) {
        var i, indent, j, ref;
        indent = "";
        for (i = j = 0, ref = this.level; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          indent += " ";
        }
        return indent + syntax;
      }
    };

    Assembler.parse = function(segment) {
      var adverb, close, closure, closures, j, k, l, len, len1, len2, len3, len4, len5, level, line, m, n, o, open, phrase, ref, ref1, ref2, ref3, syntax, verb;
      level = this.indent.level;
      syntax = [];
      closures = [];
      for (j = 0, len = segment.length; j < len; j++) {
        phrase = segment[j];
        if (phrase.type === 'verb') {
          for (k = 0, len1 = verbs.length; k < len1; k++) {
            verb = verbs[k];
            if (phrase.verb === verb.lexical.base) {
              ref = verb.syntax(phrase);
              for (l = 0, len2 = ref.length; l < len2; l++) {
                line = ref[l];
                syntax.push(this.indent.exec(line));
              }
            }
          }
        }
        if (phrase.type === 'adverb') {
          for (m = 0, len3 = adverbs.length; m < len3; m++) {
            adverb = adverbs[m];
            if (ref1 = phrase.adverb, indexOf.call(Object.keys(adverb.types), ref1) >= 0) {
              ref2 = adverb.syntax(phrase), open = ref2[0], close = ref2[1];
              for (n = 0, len4 = open.length; n < len4; n++) {
                line = open[n];
                syntax.push(this.indent.exec(line));
              }
              closures.push(close);
              this.indent.inc();
            }
          }
        }
      }
      ref3 = closures.reverse();
      for (o = 0, len5 = ref3.length; o < len5; o++) {
        closure = ref3[o];
        this.indent.dec();
        syntax.push(this.indent.exec(closure));
      }
      return syntax.join("\n");
    };

    return Assembler;

  })();

  module.exports = Assembler;

}).call(this);