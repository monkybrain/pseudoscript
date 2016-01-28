huejay = require "huejay"
util = require "util"
Promise = require "promise"

client = new huejay.Client
  host: '192.168.0.198'
  username: '729c9abad20352b1a8a56cc2bf2a0b6'

ready = false

class Hue

  @ready: () ->
    new Promise (resolve, reject) ->

      # Loop function
      run = () ->

        # If ready -> resolve
        if ready then resolve('Hue ready')

        # Else wait 5 ms and try again
        else setTimeout () ->
          run()
        , 5

      # Start loop
      run()

  @lights = []

  set: (options) ->

### INIT ###
lights = client.lights.getAll().then(
  (lights) ->
    Hue.lights = lights
    ready = true
  (error) ->
    console.error error
)

module.exports = Hue