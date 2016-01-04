map = require './map'
Room = map.Room
Light = map.Light

Photon = require './photon'
photon = new Photon()

console.log '# Running script #'
photon.connect()
.then () ->

  # Create Light called 'undefined'
  new Light('undefined', photon)


  # Set the property 'color' of 'undefined' to 'green'
  Light.get('undefined').set('color', 'green')

.then () ->

  # Set the property 'color' of 'undefined' to 'red'
  Light.get('undefined').set('color', 'red')

.then () ->
  console.log '# End of script #'