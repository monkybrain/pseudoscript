map = require './map'
Room = map.Room
Light = map.Light

Photon = require './photon'
photon = new Photon()

console.log '# Running script #'
photon.connect()
.then () ->

  # Create Light called 'test'
  new Light('test', photon)


  # Set the property 'on' of 'test' to false
  Light.get('test').set('on', false)

.then () ->
  console.log '# End of script #'