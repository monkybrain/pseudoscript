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

  # Create Room called 'bedroom'
  new Room('bedroom', photon)
  # Create anonymous Button
  new Button(null, photon)
  # Create Light called 'test'
  new Light('test', photon)

  # Set the property 'brightness' of 'test' to 20
  Objekt.get('test').set('brightness', 20)
  
  # Setting callback for event 'pushed' of current Button
  Button.get().on 'pushed', () ->

    # Set the property 'color' of 'test' to 'blue'
    Objekt.get('test').set('color', 'blue')


    # Setting timeout to 1000 ms
    setTimeout () ->

      # Set the property 'color' of 'test' to 'red'
      Objekt.get('test').set('color', 'red')

    , 1000
  
  # Setting callback for event 'dark' of 'bedroom'
  Objekt.get('bedroom').on 'dark', () ->

    # Set the property 'brightness' of 'test' to 200
    Objekt.get('test').set('brightness', 200)
  
  # Setting callback for event 'light' of 'bedroom'
  Objekt.get('bedroom').on 'light', () ->

    # Set the property 'brightness' of 'test' to 20
    Objekt.get('test').set('brightness', 20)
