dictionary = require "./dictionary"
map = require "./map"
Parser = require "./parser"

p = new Parser(dictionary, map)
# console.log p.parse "turn on the light, set the brightness to 45 and the timer to 20 minutes"
# console.log p.parse "add a light called 'fisk', set the brightness to 20, turn it on and set the timer to 2 hours"
# console.log p.parse "add a light called 'kitchen light', turn it on and set the brightness of 'ceiling light' to 4"