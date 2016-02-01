### VERB: LOG ###

modules = require "../../modules/modules"
Verb = require "../../parts/verbs/verb"
Scope = require "../../parts/scope"

class Log extends Verb

  @lexical:
    base: 'log'
    synonyms: ['log']

  @test: (text) ->
    pattern = /\blog\b.*/g
    match = text.match pattern
    if match
      split = @split match[0]
      return type: 'verb', verb: 'log'

  @syntax: (phrase) ->
    syntax = []
    syntax.push "# Logging"
    syntax.push ".then (response) ->"
    syntax.push "  console.log \"\#{response.ref} (\#{response.object})\""
    syntax.push "  console.log \"  \#{key}: \#{value}\" for key, value of response.properties"
    # syntax.push "  console.log 'fisk'"
    syntax

module.exports = Log

