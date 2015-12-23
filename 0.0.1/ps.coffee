# Paths
paths =
  dictionary: "./dictionary"
  map: "./map"

# Imports
map = require paths.map
dictionary = require paths.dictionary
Parser = require "./parser"

# helpers
log = (info) ->
  console.log info


parser = new Parser(map, dictionary)

pseudoLines = [
  "let there be a room"
  "create another room called 'bedroom'"
  "add a light to the room"
]
coffeeLines = pseudoLines.map (line) ->
  parser.parse line

console.log parser.wrap(coffeeLines, pseudoLines, paths.map)


# pseudoString = "let there be a room"
#parser.parse pseudoString
#pseudoString = "in that room"
#parser.parse pseudoString
return


# Always start with new universe

# pseudo: let there be light
u = new Universe()

###
# pseudo: let there be a room called "bedroom"
u.add new Room "bedroom"
# pseudo: let there be a room called "living room"
u.add new Room "bedroom"
###


log "\nUniverse contains:"
log u.contains
log "\nCurrent scope:"
log u.scope


###

u.contains.push(new Light())
log u.contains
###



# scopes
# top scope: universe

# god like syntax:
# let there be a house (called home)
# create room

