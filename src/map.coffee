Promise = require "promise"

class Objekt
# 'Object' already taken...

  @members = []

  @index = 0

  constructor: (ref, photon) ->
    if ref? then @ref = ref
    if photon? then @photon = photon
    @children = []
    @constructor.members.push this
    @constructor.index++

  add: (object) ->
    @children.push object.ref

  set: (property, value) ->

    console.log "Setting #{property} of '#{this.ref}' to #{value}"

    # Factorize this!
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
          console.log "Done!"
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
    for member in @.members
      if ref is member.ref
        return member

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

  constructor: (ref, photon) ->
    super(ref, photon)

objects = {
  Light: Light
  Room: Room
}

module.exports = objects