### generated by pseudoscript 0.1 ###

# Core modules
Util = require '../src/core/util'

# Custom modules
Light = require '../src/modules/light'
Room = require '../src/modules/room'

# Adding new Light 'Hue 1'
new Light 'Hue 1'

# Setting properties of 'Hue 1'
Light.select 'Hue 1'
.then -> Light.set
  hue: 5000
  brightness: 100
  saturation: 100

# Getting properties of 'Hue 1'
Light.select 'Hue 1'
.then -> Light.get ['hue', 'saturation']

# Multiplying
.then (operands) -> Util.math.multiply [operands.hue, operands.saturation]

# Logging
.then (response) -> console.log response
