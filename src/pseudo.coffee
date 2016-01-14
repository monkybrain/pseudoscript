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
Parser = require "./../core/parser"
Assembler = require "./../core/assembler"
Preprocessor = require "./../core/preprocessor"

# user modules
modules = require "./modules/modules"

# Get filename
if argv._[0]?
  filename = argv._[0]
else
  error "Error: no input!"
  return

# Read file
try
  file = fs.readFileSync filename, "utf8"
catch err
  error "Error: could not open #{filename}"
  return



### PREPROCESSOR ###
lines = Preprocessor.process file



### PARSER ###
segments = lines.map (line) ->
  Parser.parse line

# if '-s' -> log segments
if argv.s?
  console.log util.inspect segments, false, 8



### ASSEMBLER ###
code = []
for segment in segments
  # Assemble program
  code.push Assembler.parse segment

console.log code.join "\n"
return

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

