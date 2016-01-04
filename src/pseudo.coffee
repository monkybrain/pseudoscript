# External modules
argv = require("yargs").argv
shell = require "shelljs"

# Internal modules
dictionary = require "./dictionary"
map = require "./map"
Parser = require "./parser"
Programmer = require "./programmer"
Photon = require "./photon"

# command = "add a light called 'ceiling light', set the brightness to 10 and the color to green"
command = "add a light called 'test', set the color to red and blink"
if argv._[0]?
  command = argv._[0]

parser = new Parser(dictionary, map)
programmer = new Programmer(map)

# Parse command
script = parser.parse command

# console.log script

# Assemble program
code = programmer.process script
program = programmer.wrap code

# console.log program

###
console.log "Generated code: "
console.log program
console.log "\n"
###

program.to "temp.coffee"
shell.exec "coffee temp.coffee"
