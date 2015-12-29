class Objekt
# 'Object' already taken...

  @members = []

  @index = 0

  constructor: (ref) ->
    if ref? then @ref = ref
    @children = []
    @constructor.members.push this
    @constructor.index++

  add: (object) ->
    @children.push object.ref

  set: (property, value) ->

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
      console.log @photon

  inc: (property, value) ->
    this.properties[property] += value

  dec: (property, value) ->
    this.properties[property] -= value

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
    'on': false
    'brightness': 5
    'timer': 10
    'color': 'white'

  constructor: (ref, photon) ->
    super(ref)
    @properties = Light.properties

class Room extends Objekt

  @word: 'room'

  constructor: (ref) ->
    super(ref)

objects = {
  Light: Light
  Room: Room
}

module.exports = objects