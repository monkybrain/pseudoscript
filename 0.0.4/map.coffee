class Abject
# 'Object' already taken...

  constructor: () ->
    @members = []

class Light extends Abject

    @word: 'light'

    @properties:
      'on': false
      'brightness': 45
      'timer': 30

    constructor: () ->
      null

    set: (property, value) ->
      if property is 'brightness'
        console.log "Brightness set to #{value}"
      if property is 'timer'
        console.log "Timer set to #{value}"

objects = {
  Light: Light
}

module.exports = objects