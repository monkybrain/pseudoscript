### GENERATED BY PSEUDOSCRIPT 0.1 ###

# Adding new Room called 'living room'
new Room('living room')

# Adding new Light called 'living room'
new Light('living room')

# Setting timeout to 30 seconds
setTimeout () ->

  # Setting 'brightness' of 'living room' to '20'
  Light.select('living room').set('brightness', '20')

, (30*1000)

