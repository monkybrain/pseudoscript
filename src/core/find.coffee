modules = require "../modules/modules"
Util = require "./util"

class Find

  constructor: () ->

  @object: (text) ->
    for module in modules
      match = text.match module.lexical.base
      if match?
        return module.self

  # TODO: Merge 'object' and 'objects'?
  @objects: (text) ->

    words = []
    for module in modules
      words.push module.lexical.base
      words.push module.lexical.plural

    pattern = Util.regex.groupAndBoundGlobal words
    matches = text.match pattern
    objects = matches.map (match) ->
      for module in modules
        if module.lexical.base is match
          return module.self

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

  @references: (text) ->
    # FIXME: SHORTEN TO ONE LINE (i.e. get better at using regex groups)
    # TODO: REWRITE @reference IN LINE WITH @references
    matches = text.match /'[^']*'/g
    if matches?
      matches.map (match) ->
        match.replace /'/g, ''

  @number: (text) ->

    # Exclude refs from number search
    refs = @references text
    if refs? then text = text.replace "'#{ref}'", '' for ref in refs

    # Perform number search (find integers and floats)
    pattern = /\b([0-9]+([.][0-9]*)*)\b/g
    match = text.match pattern

    if match?
      return match[0]

  @boolean: (text) ->
    pattern = /\b((true)|(false))\b/g
    match = text.match pattern
    if match?
      return match[0]


module.exports = Find