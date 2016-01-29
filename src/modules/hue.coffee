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

  @light:
    set: (id, options) ->
      new Promise (resolve, reject) ->
        Hue.ready().then( -> client.lights.getById(id) )
        .then(
          (light) ->
            for key, value of options
              light[key] = value
            client.lights.save light
          (error) ->
            console.error error
        ).then(
          (success) -> resolve()
          (error) -> reject error
        )

### INIT ###
###Hue.lights = [
  light: attributes: {attributes: {name: 'Hue 1'}},
  light: attributes: {attributes: {name: 'Hue 2'}}]
ready = true###

lights = client.lights.getAll().then(
  (lights) ->
    Hue.lights = lights
    ready = true
  (error) ->
    console.error error
)

module.exports = Hue