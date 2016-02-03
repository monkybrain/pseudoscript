Promise = require "promise"

class Util

  @regex:
    groupAndBound: (expressions) ->
      words = expressions.join "|"
      pattern = new RegExp "\\b" + words + "\\b"
    group: (expressions) ->
      pattern = expressions.map (expression) ->
        "(" + expression + ")"
      pattern = pattern.join "|"
    enclose: (expression) ->
      "(" + expression + ")"
    bound: (pattern) ->
      new RegExp "\\b(" + pattern + ")\\b", "g"

  @debug: (string) ->
    console.log string

module.exports = Util