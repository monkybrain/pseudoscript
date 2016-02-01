### VERB: LOG ###

modules = require "../../modules/modules"
Verb = require "../../parts/verbs/verb"
Scope = require "../../parts/scope"

class Log extends Verb

  @lexical:
    base: 'log'
    synonyms: ['log']

  @test: (text) ->
    pattern = /\blog\b(\s+?(.*))*/
    match = text.match pattern
    if match?
      properties = match[2]
      if properties?
        properties = @split properties
      return type: 'verb', verb: 'log', properties: properties

  @syntax: (phrase) ->
    syntax = []
    syntax.push "# Logging"
    if not phrase.properties?
      syntax.push ".then (response) -> console.log response\n"
    else
      syntax.push ".then ->"
      for property in phrase.properties
        syntax.push "  console.log \"#{property}: \" + Globals['#{property}']"
      syntax[syntax.length - 1] = syntax[syntax.length - 1] + "\n"
    syntax

module.exports = Log

