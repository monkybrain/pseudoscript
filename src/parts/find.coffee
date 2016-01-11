modules = require "../modules/modules"
# dict = require "../dictionaries/base"

class Find

  constructor: () ->

  @test: () ->
    console.log "test"

  @object: (text) ->

    # Look for words corresponding to loaded modules
    for module in modules
      match = text.match module.lexical.base
      if match?
        return module.self

  @module: (object) ->

    for module in modules
      match = object.match module.self
      if match?
        return module

  @reference: (text) ->

    # Empty array of indices
    indices = []

    # Define pattern
    pattern = /"|'/g

    # Find all single and double quotes (TODO: Disallow combinations of single and double qoutes)
    loop
      match = pattern.exec text
      if match? then indices.push match.index else break

    # Cut out reference from text and return
    if indices.length > 0
      start = indices[0] + 1
      end = indices[1]
      return text[start...end]

module.exports = Find