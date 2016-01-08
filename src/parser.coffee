tools = require "monky-tools"
Parts = require "./parts/parts"

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

    ### SET ###
    result = Parts.set.test line
    if result?
      segments.push result

    segments

module.exports = Parser