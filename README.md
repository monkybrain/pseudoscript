# pseudoscript #

Transpiles pseudo code in to CoffeeScript/JavaScript.

It's kind of magic...

### Status ###
Protohack!

### Wanna give it a try? ###
run `coffee process.coffee` in `0.0.3/` for a very limited preview (edit the input at the end of the file)

### Actual, working examples (intended for home automation scripting) ###

```
# turn on the light and set the timer to 30 minutes
light.on = true
light.timer = 30

# turn on the light, increase the light's brightness to 50 and increase it again by 20
light.on = true
light.brightness = 50
light.brightness += 50

# turn the light off please and set the timer to 20 minutes, okay?
light.on = false
light.timer = 20

# turn on the bloody light and set the bleeding brightness to 45 you pathetic excuse for a home automation system!
# (even handles abuse...)
light.on = true
light.on = 45

# turn the light's brightness up to 40 would ya?
light.brightness = 40

```

### Features to be implemented soon ###

Questions

```
# is the light on? what is the brightness (set to)?
console.log "On: " + light.on
console.log "Brightness: " + light.brightness

```

Events
```
# when the room gets dark, turn on the light
# or: when darkness falls, enlighten us!
room.event 'dark', () ->
  light.on = true
```

Conditional statements
```
# if the light has been on for more than 30 minutes, turn it off
if light.upTime > 30 then light.on = false
```