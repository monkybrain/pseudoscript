modules = require "../modules/modules"

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

  @word: (object) ->
    for module in modules
      match = object.match module.self
      if match?
        return module.lexical.base

  @getModuleByRef: (ref) ->
    for module in modules
      for member in module.members
        if ref is member then return module.self

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

  @references: (text) ->
    # FIXME: SHORTEN TO ONE LINE (i.e. get better at using regex groups)
    # TODO: REWRITE @reference IN LINE WITH @references
    matches = text.match /'[^']*'/g
    if matches?
      matches.map (match) ->
        match.replace /'/g, ''

  @number: (text) ->
    # pattern = /\b\d+(\.\d+)?\b/g
    pattern = /\b[0-9]*[.][0-9]+\b/g
    match = text.match pattern
    if match?
      console.log match
      return match[0]

  @boolean: (text) ->
    pattern = /\b((true)|(false))\b/g
    match = text.match pattern
    if match?
      return match[0]


module.exports = Find