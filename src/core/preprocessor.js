// Generated by CoffeeScript 1.10.0
var Find, Preprocessor, dict, modules,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

dict = require("./../dictionaries/dictionary");

modules = require("./../modules/modules");

Find = require("./find");

Preprocessor = (function() {
  function Preprocessor() {}

  Preprocessor.numbers = dict.preprocessor.numbers;


  /* SINGLE LINE OPERATIONS */

  Preprocessor.trim = function(line) {
    return line.trim();
  };

  Preprocessor.replace = function(line) {
    var i, len, num, ref1, word, words;
    ref1 = this.numbers;
    for (num in ref1) {
      words = ref1[num];
      for (i = 0, len = words.length; i < len; i++) {
        word = words[i];
        line = line.replace(word, num);
      }
    }
    return line;
  };

  Preprocessor.lowercase = function(line) {
    var i, len, ref, refs;
    refs = Find.references(line);
    line = line.toLowerCase();
    for (i = 0, len = refs.length; i < len; i++) {
      ref = refs[i];
      line = line.replace(ref.toLowerCase(), ref);
    }
    return line;
  };

  Preprocessor.comments = function(line) {
    var index;
    index = line.indexOf("#");
    if (index !== -1) {
      return line.slice(0, index);
    } else {
      return line;
    }
  };


  /* MULTILINE OPERATIONS */

  Preprocessor.split = function(file) {
    return file.split(/(\n)|(\.)/g);
  };

  Preprocessor.filter = function(lines) {
    return lines.filter(function(line) {
      var patterns;
      patterns = ['', void 0, null, "\.", "\n"];
      if (indexOf.call(patterns, line) >= 0) {
        return false;
      } else {
        return true;
      }
    });
  };


  /* PHRASES */

  Preprocessor.phrases = function(line) {
    var i, j, len, len1, module, object, pattern, phrase, ref1, translation;
    for (i = 0, len = modules.length; i < len; i++) {
      module = modules[i];
      if (module.lexical.phrases != null) {
        ref1 = module.lexical.phrases;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          phrase = ref1[j];
          pattern = new RegExp(phrase.pattern.replace("<object>", "(\\w*\\s*)*\\'((\\w+)?(\\s+?\\w+?)*)'"));
          if (typeof match !== "undefined" && match !== null) {
            console.log(match);
            object = match[2];
            translation = phrase.verb + " '" + object + "' " + phrase.property + " " + phrase.value;
            line = line.replace(pattern, translation);
          }
        }
      }
    }
    return line;
  };

  Preprocessor.process = function(file) {
    var lines;
    lines = this.filter(this.split(file));
    lines = lines.map((function(_this) {
      return function(line) {
        return line = _this.replace(_this.trim(_this.lowercase(_this.comments(line))));
      };
    })(this));
    return this.filter(lines);

    /*lines = lines.map (line) =>
      @phrases line
     */
  };

  return Preprocessor;

})();

module.exports = Preprocessor;
