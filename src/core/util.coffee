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



module.exports = Util