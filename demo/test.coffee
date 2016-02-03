### generated by pseudoscript 0.1 ###

# Core modules
Util = require '../src/core/runtime/util'
Globals = require '../src/core/runtime/globals'

# Custom modules
Light = require '../src/modules/light'
Room = require '../src/modules/room'
Shaker = require '../src/modules/shaker'

# Add new Light 'Hue 1'
new Light 'Hue 1'

# Add new Light 'Hue 2'
new Light 'Hue 2'

# Add new Shaker 'shaker 1'
new Shaker 'shaker 1'

# Set properties of 'Hue 2'
Light.set 'Hue 2', 
  hue: 50000
  saturation: 240
  brightness: 150
.then (result) -> Globals.set result

# Catch errors
.catch (err) -> Util.error err

# Set properties of 'Hue 1'
Light.set 'Hue 1', 
  hue: 30000
  saturation: 240
  brightness: 150
.then (result) -> Globals.set result

# Catch errors
.catch (err) -> Util.error err

# Set interval to 2 seconds
setInterval ->

  # Set properties of 'Hue 1'
  Light.set 'Hue 1', 
    hue: Util.random min: 0, max: 65535
    transitionTime: 0.1
  .then (result) -> Globals.set result

  # Log
  .then (response) ->
    # Logging response
    Util.log response
    Util.log ''
  # Catch errors
  .catch (err) -> Util.error err

, 2 * 1000

# Set interval to 3 seconds
setInterval ->

  # Set properties of 'Hue 2'
  Light.set 'Hue 2', 
    hue: Util.random min: 0, max: 65535
    transitionTime: 3
  .then (result) -> Globals.set result

  # Log
  .then (response) ->
    # Logging response
    Util.log response
    Util.log ''
  # Catch errors
  .catch (err) -> Util.error err

, 3 * 1000