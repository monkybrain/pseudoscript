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

  # Set the property 'on' of 'test' to true
  Light.get('test').set('on', true)

.then () ->

  # Set the property 'color' of 'test' to 'red'
  Light.get('test').set('color', 'red')

.then () ->


  # Blink 3 times
  Light.get('test').do('blink', 3)

.then () ->

  console.log '# End of script #'