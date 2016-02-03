### UTIL: RUN TIME ###

Promise = require "promise"

class Util

  @random: (options) ->
    Math.floor(options.min + Math.random() * options.max)

  @error: (err) ->
    console.error err

  @log: (string) ->
    new Promise (resolve, reject) ->
      console.log string
      resolve()

  @math:
    multiply: (operands...) ->
      new Promise (resolve, reject) ->
        resolve operands.reduce (prev, curr) -> prev * curr
    divide: (operands) ->
      new Promise (resolve, reject) ->
        resolve operands.reduce (prev, curr) -> prev / curr
    add: (operands) ->
      new Promise (resolve, reject) ->
        resolve operands.reduce (prev, curr) -> prev + curr
    subtract: (operands) ->
      new Promise (resolve, reject) ->
        resolve operands.reduce (prev, curr) -> prev - curr

module.exports = Util