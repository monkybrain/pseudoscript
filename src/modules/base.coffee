Promise = require "promise"

class Objekt
# 'Object' already taken...

  @word: 'object'

  @members = []
  @scope = null

  @index = 0

  constructor: (ref, photon) ->
    if ref? then @ref = ref else @ref = @constructor.word + @constructor.index
    if photon? then @photon = photon
    @children = []
    @constructor.members.push this
    @constructor.index++
    @constructor.scope = @ref

  add: (object) ->
    @children.push object.ref

  # TODO: HACK! FIND PROPER PLACE FOR THIS AND IMPLEMENT ERROR HANDLING AS BELOW WITH 'SET'
  do: (action, times) ->

    console.log "Performing action '#{action}' #{times} time" + if times isnt 1 then "s" else ""

    @photon.do(action, times).then(
      (result) ->
        # console.log 'Done!'
      (err) ->
       console.error err
     )

  set: (property, value) ->

    console.log "Setting property '#{property}' of '#{this.ref}' to #{value}"

    # Check if valid property and value (TODO: CLEAN THIS MESS UP!)
    for key of @properties
      if property is key
        found = true
        break
    if not found?
      # Error
      console.error "Invalid property"
    else
      # Make sure value is of right type
      if typeof value is typeof this.properties[property]
        # Set property
        this.properties[property] = value
      else
        # Error
        console.error "Invalid value"
    if @photon
      @photon.set(property, value).then(
        (result) ->
          # console.log "Done!"
        (err) ->
          console.error err
      )

  inc: (property, value) ->
    this.properties[property] += value
    @set property, this.properties[property]

  dec: (property, value) ->
    this.properties[property] -= value
    @set property, this.properties[property]

  alreadyUsing: (ref) ->
    ref in @constructor.members

  @get: (ref) ->
    if not ref?
      ref = @scope

    for member in @.members
      if ref is member.ref
        return member

  on: (event, callback) ->
    @photon.on event, callback

class Light extends Objekt

  @word: 'light'

  # Default values
  @properties:
    'on': true
    'brightness': 5
    'timer': 10
    'color': 'white'

  constructor: (ref, photon) ->
    super(ref, photon)
    @properties = Light.properties

class Room extends Objekt

  @word: 'room'

  @events:
    'dark':
      event: 'dark'
    'light':
      event: 'light'

  constructor: (ref, photon) ->
    super(ref, photon)
    @events = Room.events

class Button extends Objekt

  @word: 'button'

  @events:
    '\\b((push)|(pushed)|(pushes))\\b':
      event: 'pushed'

  @properties:
    'active': true

  constructor: (ref, photon) ->
    super(ref, photon)
    @events = Button.events
    @properties = Button.properties


objects = {
  Objekt: Objekt
  Light: Light
  Room: Room
  Button: Button
}

module.exports = objects