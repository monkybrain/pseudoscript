#! /usr/bin/env node

// Generated by CoffeeScript 1.10.0
(function() {
  var Parser, Photon, Programmer, argv, code, command, dictionary, map, parser, program, programmer, script, shell;

  argv = require("yargs").argv;

  shell = require("shelljs");

  dictionary = require("./dictionary");

  map = require("./map");

  Parser = require("./parser");

  Programmer = require("./programmer");

  Photon = require("./photon");

  if (argv._[0] != null) {
    command = argv._[0];
  }

  parser = new Parser(dictionary, map);

  programmer = new Programmer(map);

  script = parser.parse(command);

  code = programmer.process(script);

  program = programmer.wrap(code);


  /*
  console.log "Generated code: "
  console.log program
  console.log "\n"
   */

  program.to("temp.coffee");

  shell.exec("coffee temp.coffee");

}).call(this);