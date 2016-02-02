### ADVERB: WHEN ###

### TODO: MOVE TO ADVERBS! ###

modules = require "../../modules/modules"
Module = require "../../modules/module"
Scope = require "./../scope"
Find = require "./../../core/find"
Adverb = require "./../verbs/verb"
dict = require("../../dictionaries/dictionary").adverbs

class When extends Adverb

  @lexical:
    base: 'when'
    synonyms: ['when']

  @types: dict['when'].types

  @split: (text) ->

    # Define delimiter pattern
    pattern = /\s+and\s+|,|\s+&\s+/g

    # Split by pattern
    parts = text.split pattern

    # Return array of trimmed strings
    parts = parts.map (part) ->
      part.trim()

    # If empty -> remove from array (to prevent trailing 'and's)
    parts.filter (part) ->
      part isnt ''

  # TODO: FACTORIZE AND MOVE TO PARENT! (SAME FOR 'SET', 'GET' etc.)
  @getObject: (segment) ->

    ### FIND OBJECT AND REFERENCE ###

    # Search for object
    for module in modules
      match = segment.match module.lexical.base
      if match?
        object = module.self
        break

    # Search for reference
    ref = Find.reference segment

    # If no object...
    if not object?
      # ...but ref -> fetch from members
      if ref?
        try
          object = Module.fetch(ref).module
        catch err
          console.error "Error! '#{ref}' not found."
      # ...else -> fetch from scope
      else
        object = Scope.current.object
        ref = Scope.current.ref

    # If object...
    else
      ref = Scope.modules[object].ref

    return [object, ref]

  @getEvent: (segment) ->
    for module in modules
      if module.events?
        for key, value of module.events
          return key

  @parse: (segment) ->
    [object, ref] = @getObject segment
    event = @getEvent segment
    return [object, ref, event]

  @test: (text) ->
    pattern = /\bwhen\b/g
    match = text.match pattern
    if match?
      # TODO: Add split later!
      [object, ref, event] = @parse match[0]
      return type: 'adverb', adverb: 'when', object: object, ref: ref, event: event

  @syntax: (phrase) ->
    {adverb: adverb, object: object, ref: ref, event: event} = phrase
    open = []
    open.push "# On event '#{event}' for '#{ref}'"
    open.push "#{object}.on '#{ref}', '#{event}', () ->\n"
    close = ["\n"]
    return [open, close]



module.exports = When