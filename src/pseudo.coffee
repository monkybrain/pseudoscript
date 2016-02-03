### IMPORTS ###

# node modules
fs = require "fs"
util = require "util"

# npm modules
argv = require("yargs").argv
shell = require "shelljs"

# monky-tools
log = require("monky-tools").console.log
error = require("monky-tools").console.error

# core modules
Parser = require "./core/parser"
Assembler = require "./core/assembler"
Preprocessor = require "./core/preprocessor"


### SCRIPT ###

# HELP
# -h/--help: help
if argv.h? or argv.help?
  help = []
  help.push ""
  help.push "### pseudoscript v 0.1 ###\n"
  help.push "  Usage: pseudo [input file] [options]\n"
  help.push "    -s (--segments)\tshow deconstructed segments (mainly for debugging purposes)"
  help.push "    -c (--compile)\tshow compiled CoffeeScript source"
  help.push "    -r (--run)\t\trun script"
  help.push "    -o (--output)\tcompile to file ('--output temp.coffee')"
  help.push ""
  console.log help.join "\n"
  process.exit()
  return

# Get filename (exit on error)
if argv._[0]? then filename = argv._[0]
else error "Error: no input!"; return

# Read pseudoscript file (exit on error)
try file = fs.readFileSync filename, "utf8"
catch err
  error "Error: could not open #{filename}"
  return

# Preprocessor: prepare input for parsing
lines = Preprocessor.process file

# Parser: deconstruct input
segments = lines.map (line) -> Parser.parse line

# Assembler: assemble output
code = segments.map (segment) -> Assembler.parse segment
code = Assembler.wrap code
code = code.join "\n"

# Process arguments

# -s: show segments
if argv.s? or argv.segments?
  for segment, index in segments
    console.log "\nLine #{index+1}:\n" + util.inspect segment, false, 8
  console.log "\n"

# -l: log
if argv.c? or argv.compile?
  console.log code

# -o/--output: output filename
if argv.o? or argv.output?
  # -o: output file name
  if argv.o?
    if typeof argv.o isnt 'string'
      error "Error! No output file name"
    else
      code.to argv.o
  # --output: output file name
  else if argv.output?
    code.to argv.output
  else
    error "Error! No output file name"

# -r: run
if argv.r?
  code.to ".temp"
  shell.exec "coffee .temp", () ->
    console.log "done"
else
  process.exit()