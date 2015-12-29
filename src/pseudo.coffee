dictionary = require "./dictionary"
map = require "./map"
argv = require("yargs").argv
Parser = require "./parser"
Programmer = require "./programmer"
Photon = require "./photon"

command = "add a light called 'ceiling light', set the brightness to 45 and increase the timer by 10 minutes"
if argv._[0]?
  command = argv._[0]

photon = new Photon()
photon.connect().then(
  () ->
    console.log "connected"
    photon.set('color', 'white').then (result) ->
      console.log result
      photon.set('brightness', '100').then (result) ->
        console.log result
  (err) ->
    console.error err
  )

return
parser = new Parser(dictionary, map)
programmer = new Programmer(map)
script = parser.parse command
# console.log script
code = programmer.process script
# console.log p.parse "add a light called 'kitchen light', turn it on and set the brightness of 'ceiling light' to 4"
console.log programmer.wrap code