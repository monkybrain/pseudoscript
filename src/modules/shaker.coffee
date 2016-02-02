Module = require "./module"
SensorTag = require "sensortag"
util = require "util"

class Shaker extends Module

  @self: 'Shaker'

  @lexical:
    base: 'shaker'
    plurals: 'shakers'

  @members: []

  @properties: null

  @events:
    'shake': -> console.log "nothing"

  constructor: (@ref) ->

    @tag = null
    @events = Shaker.events
    @connected = false

    Shaker.members.push this

  @connect: (ref) ->

    new Promise (resolve, reject) =>

      for member in Shaker.members

        if member.ref is ref

          SensorTag.discover (tag) ->

            member.tag = tag

            # Remove this pyramid of doom
            member.tag.connectAndSetUp (err) ->
              if err? then console.error err and process.exit()

              member.tag.enableAccelerometer (err) ->
                if err? then console.error err and process.exit()

                member.tag.setAccelerometerPeriod 200, (err) ->
                  if err? then console.error err and process.exit()

                  member.tag.notifyAccelerometer (err) ->
                    if err? then console.error err and process.exit()

                    member.connected = true

                    member.tag.on 'accelerometerChange', (x, y, z) ->

                      axes = [
                        Math.abs x
                        Math.abs y
                        Math.abs z
                      ]

                      movement = axes.reduce (prev, curr) -> prev + curr
                      if movement > 4 then member.events.shake()

                      resolve()

  @on: (ref, event, callback) ->

    new Promise (resolve, reject) =>

      for member in Shaker.members

        if member.ref is ref

          if not member.connected
            console.log "Connecting..."
            Shaker.connect member.ref
            .then =>
              member.events.shake = -> console.log "slow"
              resolve()
          else
            member.events.shake = -> console.log "fast"
            resolve()

module.exports = Shaker

###new Shaker 'shaker 1'
# Shaker.connect 'shaker 1'
Shaker.on 'shaker 1', 'shake', () -> console.log "blubb"
.then -> console.log "done"

setTimeout ->
  console.log "Changing callback"
  Shaker.on 'shaker 1', 'shake'
, 5000###

# Shaker.on 'shaker 1', 'shake', () -> console.log "shaking"
#.then -> console.log Shaker.members