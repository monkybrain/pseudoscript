tools = require "monky-tools"
Parts = require "./parts/parts"
Scope = require "./parts/scope"
Util = require "./util"

log = tools.console.log
error = tools.console.error

class Parser

  @process: (line) ->
    line = line.toLowerCase()

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

  @parse: (line) ->

    line = @process line

    segments = []

    phrases = @phrasify line

    for phrase in phrases

      ### ADVERB ###
      for adverb in Parts.adverbs
        result = adverb.test phrase
        if result?
          segments.push result

      ### VERBS ###
      for verb in Parts.verbs
        result = verb.test phrase
        if result?
          Scope.type = 'verb'
          Scope.subtype = verb.lexical.base
          segments.push result

    segments

module.exports = Parser