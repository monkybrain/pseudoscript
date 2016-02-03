tools = require "monky-tools"
Parts = require "./../parts/parts"
Scope = require "./../parts/scope"
Util = require "./util"
modules = require "./../modules/modules"

log = tools.console.log
error = tools.console.error

class Parser

  @phrasify: (line) ->

    # Assemble regex pattern from keywords
    keywords = Util.regex.group Parts.keywords
    pattern = Util.regex.bound keywords

    # Get indices of all keywords
    indices = []
    loop
      result = pattern.exec line
      if result?
        indices.push result.index
      else break

    # Sort indices (ascending)
    indices.sort (a, b) ->
      a > b

    # FIXME: CONFUSING TERMINOLOGY BELOW? (index, indices, i)

    # Divide line into segments
    phrases = []
    for index, i in indices
      if not indices[i+1]?
        phrases.push line[index...]
        break
      else
        phrases.push line[index...indices[i+1]]

    phrases

  @action: (phrase, scope) ->

    # TODO: MOVE TO BETTER PLACE
    # TODO: UGLY!
    # TODO: FIX! DUPLICATE ACTION WORDS NOT ALLOWED

    list = {}

    for module in modules
      list[module.self] = []
      for key, value of module.actions
        list[module.self].push key

    for key, value of list
      if value.length is 0
        delete list[key]

    for key, value of list
      match = phrase.match value
      if match?
        return type: 'action', action: value, object: Scope.current.object, ref: Scope.current.ref

  @parse: (line) ->

    segments = []

    phrases = @phrasify line

    for phrase in phrases

      ### ADVERB ###
      for adverb in Parts.adverbs
        result = adverb.test phrase
        if result?
          segments.push result

      ### VERBS (GENERAL) ###
      for verb in Parts.verbs
        result = verb.test phrase
        if result?
          Scope.type = 'verb'
          Scope.subtype = verb.lexical.base
          segments.push result

      ### VERBS (MODULE ACTIONS) ###
      result = @action phrase
      if result?
        segments.push result

    segments

module.exports = Parser