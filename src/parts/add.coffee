Find = require "./find"
Verb = require "./verb"

class Add extends Verb

  @lexical:
    synonyms: ['add', 'create']
    regex: () ->
      synonyms = this.synonyms.map (synonym) ->
        synonym = "(#{synonym})"
      return new RegExp "\\b(#{synonyms.join("|")})\\b", "g"

  @parse: (text) ->
    object = Find.object text
    ref = Find.reference text
    return [object, ref]

  @test: (text) ->

    # TODO: Link pattern to lexical (base & synonyms)
    pattern = @lexical.regex()
    match = text.match pattern
    if match?

      # Parse text for object and reference
      [object, ref] = Add.parse text

      # Get module
      module = Find.module object
      module.members.push ref

      return type: 'verb', verb: 'add', object: object, ref: ref

module.exports = Add