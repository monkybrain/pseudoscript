class Set

  constructor: (dict) ->
    @dict = dict

  find: (text) ->
    for entry, def of @dict.adverbs
      match = text.match def.pattern
      if match?
        return entry

  test: (text) ->
    pattern = /\bset .*( to)? \b(.*)\b/g
    match = text.match pattern
    if match?
      return match

module.exports = Set
