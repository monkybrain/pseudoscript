// Generated by CoffeeScript 1.10.0
(function() {
  var construct, dict, find, input, log, map, process, separate;

  map = require("./js/map");

  dict = require("./js/dictionary");

  log = function(info) {
    return console.log(info);
  };

  separate = function(line) {
    var clauses, i, ignore, indices, j, len, num, pattern, result, sentence, separators;
    ignore = new RegExp("(and)|,|!", "g");
    line = line.replace(ignore, " ");
    separators = Object.keys(dict.verbs).map(function(separator) {
      return "(" + separator + ")";
    });
    pattern = new RegExp(separators.join("|"), "g");
    indices = [];
    while (true) {
      result = pattern.exec(line);
      if (result === null) {
        break;
      } else {
        indices.push(result.index);
      }
    }
    clauses = [];
    for (i = j = 0, len = indices.length; j < len; i = ++j) {
      num = indices[i];
      if (indices[i + 1] != null) {
        clauses.push(line.slice(indices[i], indices[i + 1]).trim());
      } else {
        clauses.push(line.slice(indices[i]).trim());
      }
    }
    return sentence = {
      main: clauses[0],
      sub: clauses.slice(1)
    };
  };

  find = {
    verb: function(clause) {
      var definition, entry, match, ref;
      ref = dict.verbs;
      for (entry in ref) {
        definition = ref[entry];
        match = clause.match(entry);
        if (match != null) {
          return definition;
        }
      }
    },
    object: function(clause) {
      var key, match, object;
      for (key in map) {
        object = map[key];
        match = clause.match(object.word);
        if (match != null) {
          return object.word.toString();
        }
      }
    },
    property: function(clause, object) {
      var key, match, obj, property;
      for (key in map) {
        obj = map[key];
        if (obj.word === object) {
          for (property in obj.properties) {
            match = clause.match(property);
            if (match != null) {
              return property;
            }
          }
        }
      }
    },
    value: function(clause, object) {
      var match, pattern, value;
      pattern = new RegExp("(to )|(by ) ");
      match = clause.match(pattern);
      if (match != null) {
        value = clause.slice(match.index);
        value = value.replace(match[0], "");
        value = value.split(" ")[0];
        return value;
      }
    }
  };

  construct = {
    set: function(info) {
      return info.object + "." + info.property + " = " + info.value;
    },
    increase: function(info) {
      return info.object + "." + info.property + " += " + info.value;
    },
    decrease: function(info) {
      return info.object + "." + info.property + " -= " + info.value;
    },
    question: function(info) {
      return "console.log " + info.object + "." + info.property;
    },
    conditional: function(info) {
      return "if " + info.object + "." + info.property + " is " + value;
    }
  };

  process = function(input) {
    var clause, code, info, j, len, lines, newWord, property, ref, sentence, value;
    code = [];
    code.push("\n# " + input);
    sentence = separate(input);
    info = find.verb(sentence.main);
    if (info.object == null) {
      info.object = find.object(sentence.main);
    }
    if (info.property == null) {
      info.property = find.property(sentence.main, info.object);
    }
    if (info.value == null) {
      info.value = find.value(sentence.main, info.object);
    }
    lines = [];
    if (info.type === 'set') {
      lines.push(construct.set(info));
    }
    if (info.type === 'increase') {
      lines.push(construct.increase(info));
    }
    if (info.type === 'decrease') {
      lines.push(construct.decrease(info));
    }
    if (info.type === 'question') {
      lines.push(construct.question(info));
    }
    if (info.type === 'conditional') {
      lines.push(construct.conditional(info));
    }
    ref = sentence.sub;
    for (j = 0, len = ref.length; j < len; j++) {
      clause = ref[j];
      newWord = find.verb(clause);
      info.type = newWord.type;
      if (newWord.property != null) {
        info.property = newWord.property;
      }
      property = find.property(clause, info.object);
      if (property != null) {
        info.property = property;
      }
      if (newWord.value != null) {
        info.value = newWord.property;
      }
      value = find.value(clause, info.object);
      if (value != null) {
        info.value = value;
      }
      if (info.type === 'set') {
        lines.push(construct.set(info));
      }
      if (info.type === 'increase') {
        lines.push(construct.increase(info));
      }
      if (info.type === 'decrease') {
        lines.push(construct.decrease(info));
      }
    }
    code.push(lines.join("\n"));
    return code.join("\n");
  };


  /*inputs = [
     * "turn on the light and set the timer to 30 minutes"
     * "turn on the light and increase the light's brightness to 50 and increase it again by 20"
     * "turn the light off please and set the timer to 20 minutes, okay?"
     * "turn on the bloody light and set the bleeding brightness to 45 you stupid home automation system!"
   "turn the light's brightness up to 40 would ya?"
  ]
   */


  /*for input in inputs
    log process input
   */

  input = "turn on the bloody light and set the bleeding brightness to 45 you pathetic excuse for a home automation system!";

  log(process(input));

}).call(this);
