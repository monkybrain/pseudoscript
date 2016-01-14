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

# user modules
modules = require "./modules/modules"



### SCRIPT ###

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
code = code.join "\n"

# TODO: REWRITE COMPILE AND CLEANUP FUNCTIONS

# Process arguments

# -s: show segments
if argv.s?
  for segment, index in segments
    console.log "\nLine #{index+1}:\n" + util.inspect segment, false, 8
  # console.log util.inspect segments, false, 8
  console.log "\n"

# -c: compile
if argv.c?
  console.log "### GENERATED BY PSEUDOSCRIPT 0.1 ###\n"
  console.log code

return
###
script = assembler.wrap code

# Compile and run
index = filename.lastIndexOf('.')
output = filename[0...index] + ".coffee"

# If '-l' -> show generated coffeescript
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

###