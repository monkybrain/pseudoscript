# Features to be implemented soon #

### questions ###

```
# is the light on? what is the brightness (set to)?
console.log "On: " + light.on
console.log "Brightness: " + light.brightness

```

### events ###
```
# when the room gets dark, turn on the light
room.event 'dark', () ->
  light.on = true
```

### conditional statements ###
```
# if the light has been on for more than 30 minutes, turn it off
if light.upTime > 30 then light.on = false
```