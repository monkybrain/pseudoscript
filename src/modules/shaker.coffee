Module = require "./module"
SensorTag = require "sensortag"
util = require "util"

class Shaker extends Module

  @self: 'Shaker'

  @lexical:
    base: 'shaker'
    plural: 'shakers'

  @members: []

  @properties: null

  @events:
    'start': -> console.log "start"
    'stop': -> console.log "stop"

  @actions:
    'connect': null

  constructor: (@ref) ->

    @tag = null
    @events = Shaker.events
    @connected = false

    Shaker.members.push this

  @do: (ref, action) ->

    new Promise (resolve, reject) ->

      if action is 'connect'

        console.log "Connecting '#{ref}'..."

        for member in Shaker.members

          if member.ref is ref

            SensorTag.discover (tag) ->

              console.log tag

              if tag.type is 'cc2650'

                member.tag = tag

                # Remove this pyramid of doom
                member.tag.connectAndSetUp (err) ->
                  if err?
                    reject err
                  else
                    console.log member.tag
                    member.tag.enableAccelerometer (err) ->
                    if err? then console.error err and process.exit()

                    ###member.tag.setAccelerometerPeriod 200, (err) ->
                      if err? then console.error err and process.exit()

                      member.tag.notifyAccelerometer (err) ->
                        if err? then console.error err and process.exit()

                        member.connected = true

                        member.tag.on 'accelerometerChange', (x, y, z) ->

                          console.log x

                          axes = [
                            Math.abs x
                            Math.abs y
                            Math.abs z
                          ]

                          movement = axes.reduce (prev, curr) -> prev + curr
                          if movement > 4
                            console.log "movement!"
                            member.events.start()
                          resolve()###

  @on: (ref, event, callback) ->

    new Promise (resolve, reject) =>

      for member in Shaker.members

        if member.ref is ref
          member.events[event] = callback
          setInterval ->
            func = member.events[event]
            func()
            func()
          , 1000
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