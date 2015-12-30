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

photon.connect().then (

  (result) ->
    console.log "connected"

    # Set color to white
    photon.set 'color', 'white'

    # Set event listener
    ###photon.onEvent 'dark', (data) ->
      console.log "DARK"
      console.log data###

  (err) ->
    console.error err
)

setInterval () ->
  null
, 5000

return
parser = new Parser(dictionary, map)
programmer = new Programmer(map)
script = parser.parse command
# console.log script
code = programmer.process script
# console.log p.parse "add a light called 'kitchen light', turn it on and set the brightness of 'ceiling light' to 4"
console.log programmer.wrap code