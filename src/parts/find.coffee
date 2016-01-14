modules = require "../modules/modules"
# dict = require "../dictionaries/base"

class Find

  constructor: () ->

  @object: (text) ->
    for module in modules
      match = text.match module.lexical.base
      if match?
        return module.self

  # TODO: Merge 'object' and 'objects'?
  @objects: (text) ->
    matches = []
    for module in modules
      match = text.match module.lexical.base
      if match?
        matches.push module.self
    matches

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

  @number: (text) ->
    pattern = /\b\d+\b/g
    match = text.match pattern
    if match?
      return match[0]


module.exports = Find