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
map = require "./modules/base"
Parser = require "./parser"
Assembler = require "./assembler"
Photon = require "./photon"

# Create instances
parser = new Parser(dictionary, map)
assembler = new Assembler(map)

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

# if '-s' -> log segments
if argv.s?
  util.inspect segments

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

