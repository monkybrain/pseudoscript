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

  parse: (line) ->

    line = @process line

    segments = []

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