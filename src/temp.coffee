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


  # Set the property 'on' of 'undefined' to false
  Light.get('undefined').set('on', false)

.then () ->
  console.log '# End of script #'