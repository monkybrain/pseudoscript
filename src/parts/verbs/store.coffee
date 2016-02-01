Verb = require "./verb"
Scope = require "./../../parts/scope"

### NOT WORKING PROPERLY ###

class Store extends Verb

  @lexical:
    base: 'store'
    synonyms: ['store']

  @test: (text) ->
    pattern = /(\bstore)(\s+?\bas\b\s+?'(.*)')*/
    match = text.match pattern
    if match?
      key = match[3]

      return type: 'verb', verb: 'store', key: key

  @syntax: (phrase) ->
    syntax = ["# Storing"]
    if phrase.key?
      syntax.push ".then (response) -> Storage.set '#{phrase.key}', response['#{phrase.key}']\n"
    syntax

module.exports = Store