# External modules
argv = require("yargs").argv
shell = require "shelljs"
fs = require "fs"

log = require("monky-tools").console.log
error = require("monky-tools").console.error

# Internal modules
dictionary = require "./dictionary"
map = require "./map"
Parser = require "./parser"
Programmer = require "./programmer"
Photon = require "./photon"

# Create instances
parser = new Parser(dictionary, map)
programmer = new Programmer(map)

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
  segments.push parser.parse line

code = ''
for segment in segments
  # Assemble program
  code += programmer.process segment

script = programmer.wrap code

log script

script.to "temp.coffee"
shell.exec "coffee temp.coffee"
