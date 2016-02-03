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
        Hue.ready()
        .then -> client.lights.getById(id)
        .then (light) ->
          light[key] = value for key, value of options
          client.lights.save light
        .then (result) -> resolve options
        .catch (err) -> reject error

    get: (id, properties) ->
      new Promise (resolve, reject) ->
        Hue.ready().then( -> client.lights.getById(id) )
        .then(
          (light) ->
            response = {}
            for property in properties
              response[property] = light[property]
            resolve response
          (error) ->
            console.error error
        )

lights = client.lights.getAll()
.then (lights) ->
    Hue.lights = lights
    ready = true
.catch (error) -> console.error error

module.exports = Hue