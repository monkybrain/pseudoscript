Son = require "./son"
Daughter = require "./daughter"
Child = require "./child"
Parent = require "./parent"

Promise = require "promise"

test = ->
  new Promise (resolve, reject) ->
    setTimeout ->
      console.log "fisk"
      reject("error")
    , 1000

test()
.then -> console.log "done"

.catch (err) -> console.error err