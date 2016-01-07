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
      credentials = JSON.parse credentials.photon
      Spark.login credentials
      Spark.on 'login', () ->

        devices = Spark.listDevices()
        devices.then(
          (devices) ->

            Photon.photon = devices[0]

            resolve "connected"

          (err) ->
            reject err
        )

  get: (property) ->
    new Promise (resolve, reject) ->

      Photon.photon.getVariable property, (err, data) ->
        if err?
          reject err
        else
          resolve data

  set: (property, value) ->
    new Promise (resolve, reject) ->

      value = value.toString()

      Photon.photon.callFunction 'set', property + ":" + value, (err, data) ->
        if err?
          reject err
        else
          resolve data

  do: (action, times) ->
    new Promise (resolve, reject) ->

      if not times?
        times = 1
      times = times.toString()

      Photon.photon.callFunction 'do', action + ":" + times, (err, data) ->
        if err?
          reject err
        else
          resolve data

  on: (event, callback) ->
    Photon.photon.onEvent event, callback

module.exports = Photon

