class Abject
# 'Object' already taken...

  @members = []

  constructor: (ref) ->
    if ref? then @ref = ref
    @children = []

  add: (object) ->
    @children.push object.ref
    # @children.push type: type, ref: reference

  set: (p, value) ->
    property = null
    for key of @properties
      if p is key
        property = p
        break
    if not property
      console.error "Invalid property"
    else
      # Make sure value is of right type
      if typeof value is typeof this.properties[property]
        this.properties[property] = value
      else
        console.error "Invalid value"

class Light extends Abject

    @word: 'light'

    # Default values
    @properties:
      'on': false
      'brightness': 5
      'timer': 10

    constructor: (ref) ->
      super(ref)
      @properties = Light.properties
      Light.members.push this

class Room extends Abject

  @word: 'room'

  constructor: (ref) ->
    super(ref)
    @properties = Light.properties
    Room.members.push this

objects = {
  Light: Light
  Room: Room
}

#l = new Light 'fisk'
#l.set 'brightness', 10
bedrrom = new Room 'bedroom'
kitchen = new Room 'kitchen'
kitchen.add new Light 'ceiling'
console.log Room

module.exports = objects