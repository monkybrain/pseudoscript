Find = require "./../../core/find"
Scope = require "./../scope"
Verb = require "./verb"
Util = require "./../../core/util"

# ISSUE: ADD OPERATIONS (AS IN SET/GET) TO ALLOW MULTIPLE 'ADDINGS' AT ONCE

# ISSUE: At the moment, direct objects have to be stated before indirect object. 'To the room add a light' is invalid. Fix later!

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

    # Get indirect object (if present)
    match = text.match /\bto\b/g
    if match?

      # Find indirect object type
      group = objects.map (object) ->
        Find.word object
      group = "(" + Util.regex.group(group) + ")"
      match = text.match new RegExp "(to\\s+?(\\w+?\\s+?)*)" + group
      if match?
        indirect.type = Find.object match[3]

      # Find indirect object ref
      if refs?
        group = "(" + Util.regex.group(refs) + ")"
        match = text.match new RegExp "(to\\s+?(\\w+?\\s+?)*)'" + group + "'"
        if match?
          indirect.ref = match[3]

    # Get direct object
    if objects?
      [direct.type] = objects
    if refs?
      refs = refs.filter (ref) ->
        ref isnt indirect.ref
      [direct.ref] = refs


    return [direct, indirect]

  @test: (text) ->

    # TODO: Link pattern to lexical (base & synonyms)
    pattern = @lexical.regex()
    match = text.match pattern
    if match?

      # Parse text for object and reference
      [direct, indirect] = Add.parse text

      # Get module
      module = Find.module direct.type

      # If no reference specified -> generate based on index
      if not direct.ref?
        direct.ref = module.lexical.base + "_" + module.index

      if not indirect.ref?
        scope = Scope.modules[indirect.type]
        if scope?
          indirect.ref = scope.ref

      if not indirect.type?
        indirect.type = Find.getModuleByRef indirect.ref

      # Add object to module members
      module.add direct.ref

      # Update scope
      Scope.modules[direct.type] = ref: direct.ref
      Scope.current = object: direct.type, ref: direct.ref

      return {
      type: 'verb'
      verb: 'add'
      object:
        type: direct.type
        ref: direct.ref
      parent:
        type: indirect.type
        ref: indirect.ref
      }

  @syntax: (phrase) ->
    {object: object, parent: parent} = phrase
    if parent.ref?
      return [
        "# Adding new #{object.type} '#{object.ref}' to #{parent.type} '#{parent.ref}'",
        "new #{object.type} '#{object.ref}', '#{parent.ref}'\n"
      ]
    else
      return [
        "# Adding new #{object.type} '#{object.ref}'",
        "new #{object.type} '#{object.ref}'\n"
      ]




module.exports = Add