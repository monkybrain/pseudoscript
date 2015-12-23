# pseudoscript #

Transpiles pseudo code in to CoffeeScript/JavaScript.

### Status ###
Protohack!

### Wanna give it a try? ###
run `coffee process.coffee` in `0.0.3/` for a very limited preview (edit the input at the end of the file)

### Actual, working examples (intended for home automation scripting) ###

```
# turn on the light and set the timer to 30 minutes
light.on = true
light.timer = 30

# turn on the light and increase the light's brightness to 50 and increase it again by 20
light.on = true
light.brightness = 50
light.brightness += 50

# turn the light off please and set the timer to 20 minutes, okay?
light.on = false
light.timer = 20

# turn on the bloody light and set the bleeding brightness to 45 you stupid home automation system!
light.on = true
light.on = 45

# turn the light's brightness up to 40 would ya?
light.brightness = 40

```