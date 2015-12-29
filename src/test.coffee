map = require './map'
Room = map.Room
Light = map.Light

# Create Light called 'ceiling light'
new Light('ceiling light')

# Set the property 'brightness' of 'ceiling light' to 45
Light.get('ceiling light').set('brightness', 45)

# Increasing the property 'timer' of 'ceiling light' by 10
Light.get('ceiling light').inc('timer', 10)
console.log Light
