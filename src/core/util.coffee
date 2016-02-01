class Util

  @regex:
    group: (expressions) ->
      pattern = expressions.map (expression) ->
        "(" + expression + ")"
      pattern = pattern.join "|"
    enclose: (expression) ->
      "(" + expression + ")"
    bound: (pattern) ->
      new RegExp "\\b(" + pattern + ")\\b", "g"

  @random: (options) ->
    Math.floor(options.min + Math.random() * options.max)

  @math:
    multiply: (operands) ->
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