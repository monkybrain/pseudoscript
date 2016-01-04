map = require './map'
Room = map.Room
Light = map.Light

Photon = require './photon'
photon = new Photon()

console.log '# Running script #'
photon.connect()
.then () ->
  console.log 'Connected!'


  # Create Light called 'test'
  new Light('test', photon)

  # Set the property 'brightness' of 'test' to 100
  Light.get('test').set('brightness', 100)

  setInterval () ->

    # Set the property 'color' of 'test' to 'random'
    Light.get('test').set('color', 'random')

  , 1000

  photon.on 'button', () ->

    # Set the property 'color' of 'test' to 'random'
    Light.get('test').set('color', 'random')