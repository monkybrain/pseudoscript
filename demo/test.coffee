map = require '../src/modules/base'
PhotonObject = map.PhotonObject
Room = map.Room
Light = map.Light
Button = map.Button


Photon = require '../src/photon'
photon = new Photon()

console.log '# Running script #'
photon.connect()
.then () ->
  console.log 'Connected!'

  # Create anonymous Button
  new Button(null, photon)
  # Create anonymous Light
  new Light(null, photon)

  # Set the property 'brightness' of current Light
  Light.select().set('brightness', 100)
  
  # Setting callback for event 'pushed' of current Button
  Button.select().on 'pushed', () ->

    # Set the property 'color' of current Light
    Light.select().set('color', 'red')


    # Setting timeout to 1000 ms
    setTimeout () ->

      # Set the property 'color' of current Light
      Light.select().set('color', 'blue')

    , 1000
