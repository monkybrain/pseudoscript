### generated by pseudoscript 0.1 ###

Light = require "../src/modules/light"

# Adding new Light 'Hue 1'
new Light 'Hue 1'

Light.select 'Hue 1'
.then -> Light.set(hue: Math.floor Math.random() * 65000, brightness: 200, transitionTime: 1)

# setTimeout ->
#   Light.select('Hue 1').set('hue', 0)
# , 1000

