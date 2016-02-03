### UTIL: RUN TIME ###

class Util

  @random: (options) ->
    Math.floor(options.min + Math.random() * options.max)

  @error: (err) ->
    console.error err

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