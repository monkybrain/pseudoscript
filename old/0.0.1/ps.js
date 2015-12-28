// Generated by CoffeeScript 1.10.0
(function() {
  var Parser, coffeeLines, dictionary, log, map, parser, paths, pseudoLines, u;

  paths = {
    dictionary: "./dictionary",
    map: "./map"
  };

  map = require(paths.map);

  dictionary = require(paths.dictionary);

  Parser = require("./parser");

  log = function(info) {
    return console.log(info);
  };

  parser = new Parser(map, dictionary);

  pseudoLines = ["let there be a room", "create another room called 'bedroom'", "add a light to the room"];

  coffeeLines = pseudoLines.map(function(line) {
    return parser.parse(line);
  });

  console.log(parser.wrap(coffeeLines, pseudoLines, paths.map));

  return;

  u = new Universe();


  /*
   * pseudo: let there be a room called "bedroom"
  u.add new Room "bedroom"
   * pseudo: let there be a room called "living room"
  u.add new Room "bedroom"
   */

  log("\nUniverse contains:");

  log(u.contains);

  log("\nCurrent scope:");

  log(u.scope);


  /*
  
  u.contains.push(new Light())
  log u.contains
   */

}).call(this);
