map = require '../src/modules/base'
Objekt= map.Objekt
Room = map.Room
Light = map.Light
Button = map.Button


Photon = require '../src/photon'
photon = new Photon()

console.log '# Running script #'
photon.connect()
.then () ->
  console.log 'Connected!'

  # Create anonymous Light
  new Light(null, photon)

  # Set the property 'brightness' of current Light
  Light.get().set('brightness', 10)
  # Create anonymous Button
  new Button(null, photon)

  # Setting timeout to 1000 ms
  setTimeout () ->

    # Set the property 'brightness' of current Light
    Light.get().set('brightness', 100)

    # Set the property 'color' of current Light
    Light.get().set('color', 'red')

  , 1000

  # Setting interval to 5000 ms
  setInterval () ->

    # Set the property 'color' of current Light
    Light.get().set('color', 'random')

  , 5000
  
  # Setting callback for event 'pushed' of current Button
  Button.get().on 'pushed', () ->

    # Set the property 'color' of current Light
    Light.get().set('color', 'blue')
