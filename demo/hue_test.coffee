### generated by pseudoscript 0.1 ###

Light = require "../src/modules/light"

# Adding new Light 'Hue 1'
new Light 'Hue 1'

setTimeout ->
  console.log Light.select('Hue 1').set()
, 1000

