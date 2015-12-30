Spark = require "spark"
Promise = require "promise"
fs = require "fs"

class Photon

  @photon = null

  constructor: () ->
    # TODO: CHANGE TO INSTANCE VARIABLE (WHEN I CAN FIGURE OUT HOW!)
    Photon.photon = null
    @ref = 'fisk'

  connect: () ->
    new Promise (resolve, reject) ->

      credentials = fs.readFileSync "credentials.json", "utf8"
      credentials = JSON.parse(credentials)
      Spark.login credentials
      Spark.on 'login', () ->

        devices = Spark.listDevices()
        devices.then(
          (devices) ->

            Photon.photon = devices[0]

            # TODO: MOVE EVENT LISTENER TO APPROPRIATE PLACE, JUST TESTING NOW!
            Photon.photon.onEvent 'dark', (data) ->
              console.log "Incoming event! Dark: " + JSON.stringify(data)

            resolve "connected"

          (err) ->
            reject err
        )

  set: (property, value) ->
    new Promise (resolve, reject) ->

      console.log "Setting " + property + " to " + value

      if property is 'color'
        Photon.photon.callFunction 'setColor', value, (err, data) ->
          if err?
            reject err
          else
            resolve data

      if property is 'brightness'
        Photon.photon.callFunction 'setB', value, (err, data) ->
          if err?
            reject err
          else
            resolve data


module.exports = Photon

