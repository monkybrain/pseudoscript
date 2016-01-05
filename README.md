# pseudoscript

Translates pseudo code in to CoffeeScript/JavaScript.

It's kind of magic...

### Status
Hack! Trying out the principles (natural language scripting) within the area of home automation since I see great potential there.
Haven't had time to document the principles yet but hope to flesh out this README soon.

### Example
The following pseudo code...

```
Add a light called 'test' and set the brightness to 10

After 1 second, turn the brightness up to 100

Every 5 seconds, set the color to random

When button is pressed, set the color to blue
```

...results in this coffeescript


```
map = require '../src/modules/base'
Room = map.Room
Light = map.Light

Photon = require '../src/photon'
photon = new Photon()

console.log '# Running script #'

photon.connect()
.then () ->
  console.log 'Connected!'

  # Create Light called 'test'
  new Light('test', photon)

  # Set the property 'brightness' of 'test' to 10
  Light.get('test').set('brightness', 10)

  setTimeout () ->

    # Set the property 'brightness' of 'test' to 100
    Light.get('test').set('brightness', 100)

  , 1000

  setInterval () ->

    # Set the property 'color' of 'test' to 'random'
    Light.get('test').set('color', 'random')

  , 5000

  photon.on 'button', () ->

    # Set the property 'color' of 'test' to 'random'
    Light.get('test').set('color', 'blue')
```
 

 
### Video demo

This is a video of the very first working demo. At the time it could only parse one line at the time, hence the tedious repetition of 'add a light/connect to the light'. As you can see in the example above, that has now been fixed.

[![VIDEO DEMO](http://img.youtube.com/vi/sqaOa20dbRQ/0.jpg)](http://www.youtube.com/watch?v=sqaOa20dbRQ)

Please excuse the corny music. It was added by my colleague, who was nice enough to film and edit the whole thing for me. Thanks, Johan!
  