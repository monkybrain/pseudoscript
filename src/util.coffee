class Util

  @regex:
    group: (expressions) ->
      pattern = expressions.map (expression) ->
        "(" + expression + ")"
      pattern = pattern.join "|"
    bound: (pattern) ->
      new RegExp "\\b(" + pattern + ")\\b", "g"


module.exports = Util