#! /usr/bin/env node

// Generated by CoffeeScript 1.10.0

/* IMPORTS */

(function() {
  var Assembler, Parser, Preprocessor, argv, code, err, error, error1, file, filename, fs, i, index, len, lines, log, segment, segments, shell, util;

  fs = require("fs");

  util = require("util");

  argv = require("yargs").argv;

  shell = require("shelljs");

  log = require("monky-tools").console.log;

  error = require("monky-tools").console.error;

  Parser = require("./core/parser");

  Assembler = require("./core/assembler");

  Preprocessor = require("./core/preprocessor");


  /* SCRIPT */

  if (argv._[0] != null) {
    filename = argv._[0];
  } else {
    error("Error: no input!");
    return;
  }

  try {
    file = fs.readFileSync(filename, "utf8");
  } catch (error1) {
    err = error1;
    error("Error: could not open " + filename);
    return;
  }

  lines = Preprocessor.process(file);

  segments = lines.map(function(line) {
    return Parser.parse(line);
  });

  code = segments.map(function(segment) {
    return Assembler.parse(segment);
  });

  code = code.join("\n");

  if (argv.s != null) {
    for (index = i = 0, len = segments.length; i < len; index = ++i) {
      segment = segments[index];
      console.log(("\nLine " + (index + 1) + ":\n") + util.inspect(segment, false, 8));
    }
    console.log("\n");
  }

  if (argv.c != null) {
    console.log("### generated by pseudoscript 0.1 ###\n");
    console.log(code);
  }

  return;


  /*
  script = assembler.wrap code
  
   * Compile and run
  index = filename.lastIndexOf('.')
  output = filename[0...index] + ".coffee"
  
   * If '-l' -> show generated coffeescript
  if argv.l?
    log script
  
  script.to output
  
  cleanup = () ->
    if not argv.c?
      shell.rm output
  
  if argv.r?
    shell.exec "coffee " + output, () ->
      cleanup()
  else
    cleanup()
   */

}).call(this);
