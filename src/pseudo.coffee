# Node modules
fs = require "fs"
util = require "util"

# External modules
argv = require("yargs").argv
shell = require "shelljs"

# monky-tools
log = require("monky-tools").console.log
error = require("monky-tools").console.error

# Internal modules
dictionary = require "./dictionaries/base"
modules = require "./modules/modules"
Parser = require "./parser"
Assembler = require "./assembler"
Photon = require "./photon"

# Create instances
assembler = new Assembler(modules)

if argv._[0]?
  filename = argv._[0]
else
  error "Error: no input!"
  return

try
  file = fs.readFileSync filename, "utf8"
catch err
  error "Error: could not open #{filename}"
  return

# Split lines by newline and dot
lines = file.split /(\n)|(\.)/g

# Remove empty lines, nulls and dots.
lines = lines.filter (line) ->
  if line is '' then return false
  else if line is '.' then return false
  else if line is '\n' then return false
  else if not line? then return false
  else return true

# Remove comments
lines = lines.map (line) ->
  index = line.indexOf "#"
  if index isnt -1
    line = line[...index]
  line

lines = lines.filter (line) ->
  return line isnt ''

# Trim strings
lines = lines.map (line) ->
  line.trim()

segments = []
for line in lines
  segments.push Parser.parse line

console.log util.inspect segments, false, 8
return

# if '-s' -> log segments
if argv.s?
  console.log util.inspect segments, false, 4

code = ''
for segment in segments
  # Assemble program
  code += assembler.process segment

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

