class Abject
# 'Object' already taken...

  constructor: () ->
    @members = []

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
      if ref? then @ref = ref
      @properties = Light.properties

objects = {
  Light: Light
}

###l = new Light()
l.set 'brightness', 10
console.log l###

module.exports = objects