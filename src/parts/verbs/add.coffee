Find = require "./../find"
Scope = require "./../scope"
Verb = require "./verb"
Util = require "./../../core/util"

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

    direct = {}
    indirect = {}

    refs = Find.references text
    objects = Find.objects text

    # Check if indirect object present
    match = text.match /to/g
    if match?

      # Find indirect object type
      group = objects.map (object) ->
        Find.word object
      group = "(" + Util.regex.group(group) + ")"
      match = text.match new RegExp "(to\\s+?)" + group
      if match?
        indirect.object = match[2]

      # Find indirect object ref
      group = refs.map (ref) ->
        "'" + ref + "'"
      group = "(" + Util.regex.group(group) + ")"
      match = text.match new RegExp "(to\\s+?\\w+?\\s+?)" + group
      if match?
        indirect.ref = match[2]

      console.log indirect.object

      ###for ref in refs
        match = text.match new RegExp "to\\s+?'" + ref + "'", "g"
        if match?
          [indirect.ref] = match###


    # If two refs,
    if refs.length is 2

      for ref in refs
        pattern = new RegExp "to\\s+?" + ref, "g"
        match = text.match pattern
        if match?
          indirect.ref = ref
          [direct.ref] = refs.filter (ref) ->
            ref isnt indirect.ref

    console.log direct
    console.log indirect


    #### Exclude refs
    refs = Find.references text
    noRefs = text
    for ref in refs
      noRefs = noRefs.replace "'#{ref}'", ""
    ###
    # Find all objects
    objects = Find.objects noRefs

    # If only one object -> set as direct object
    if objects.length is 1
      [object] = objects

    # If two objects -> find direct and indirect objects
    if objects.length is 2
      group = Util.regex.group objects.map (object) -> Find.word object
      match = text.match group

      if match?
        console.log match
      prep = "to"
    ###

    ###object = Find.object text
    ref = Find.reference text
    return [object, ref]###

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