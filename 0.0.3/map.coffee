class Abject
# 'Object' already taken...

  constructor: () ->
    @members = []

class Light extends Object

    @word: 'light'

    @properties:
      'on': false
      'brightness': 45
      'timer': 30

    constructor: () ->
      null

objects = {
  Light: Light
}

module.exports = objects