Find = require "./../find"
Scope = require "./../scope"
Verb = require "./verb"

# ISSUE: ADD OPERATIONS (AS IN SET/GET) TO ALLOW MULTIPLE 'ADDINGS' AT ONCE

class Add extends Verb

  @lexical:
    base: 'add'
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

      # If no reference specified -> generate based on index
      if not ref?
        ref = module.lexical.base + module.index

      # Add object to module members
      module.add ref

      # Update scope
      Scope.modules[object] = ref: ref
      Scope.current = object: object, ref: ref

      return type: 'verb', verb: 'add', object: object, ref: ref, input: text

  @syntax: (phrase) ->
    {object: object, ref: ref} = phrase
    syntax = [
      "# Adding new #{object} called '#{ref}'",
      "new #{object}('#{ref}')\n"
    ]



module.exports = Add