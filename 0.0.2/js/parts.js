// Generated by CoffeeScript 1.10.0
(function() {
  var clauses, input, log, map, pattern, sentence, separators;

  map = require("./js/map");

  log = function(info) {
    return console.log(info);
  };

  input = "turn on light, set the brightness to 45 and set the timer to 20";

  separators = ["and", ","];

  pattern = new RegExp(separators.join("|"));

  clauses = input.split(pattern);

  clauses = clauses.map(function(clause) {
    return clause.trim();
  });

  sentence = {
    main: clauses[0],
    sub: clauses.slice(1)
  };

  log(sentence);

}).call(this);