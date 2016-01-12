tools = require "monky-tools"
Parts = require "./parts/parts"
Scope = require "./parts/scope"

log = tools.console.log
error = tools.console.error

class Parser

  constructor: (modules) ->
    @modules = modules
    @scope =
      verb: null
      object:
        type: null
        ref: null
      indirect:
        class: null
        ref: null
      property: null

  process: (line) ->
    line = line.toLowerCase()

  segmentize: (line) ->
    indices = []
    for keyword in Parts.keywords
      pattern = new RegExp keyword, "g"
      loop
        result = pattern.exec line
        if result?
          indices.push result.index
        else break

    segments = []

    indices.sort (a, b) ->
      a > b

    for index in [0...indices.length]
      if not indices[index+1]?
        console.log "got here"
        segments.push line[indices[index]...]
        break
      else
        segments.push line[indices[index]...indices[index+1]]

    segments

  parse: (line) ->

    line = @process line

    segments = []

    console.log @segmentize line

    ### ADVERB ###
    result = Parts.adverb.test line
    if result?
      segments.push result

    ### VERBS ###
    for verb in Parts.verbs
      result = verb.test line
      if result?
        Scope.type = 'verb'
        Scope.subtype = verb.lexical.base
        segments.push result

    segments

module.exports = Parser