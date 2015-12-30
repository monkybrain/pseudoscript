Promise = require "promise"

run = () ->
  new Promise (resolve, reject) ->
    setTimeout () ->
      resolve "done"
    , 1000


class Test

  constructor: () ->
    new Promise (resolve, reject) ->
      setTimeout () ->
        resolve "test"
      , 1000

test = new Test()
test.then (result) ->
  console.log result


###
run()

.then (result) ->
  console.log result
  run()

.then (result) ->
  console.log result
  run()
###
