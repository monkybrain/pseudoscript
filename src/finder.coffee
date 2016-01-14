class Finder

  capitalize: (string) ->
    string = string[0].toUpperCase() + string[1..]

  constructor: (dictionary, map) ->
    @dict = dictionary
    @map = map

  adverb: (clause) ->
    for entry, definition of @dict.adverbs
      match = clause.match new RegExp entry
      if match?
        return definition

  event: (clause) ->
    match = clause.match new RegExp @dict.event
    if match?

      object = {}

      # Find reference...
      ref = @reference clause
      if ref?
        object.ref = ref

      # If no reference -> find type
      if not ref?
        object.type = @capitalize @object clause

      # Find event
      for key, value of @map
        if value.events?
          for k, v of value.events
            match = clause.match k
            if match?
              return object: object, event: v.event

  verb: (clause) ->
    for entry, definition of @dict.verbs
      match = clause.match new RegExp entry
      if match?
        return definition

  object: (clause) ->
    for key, object of @map
      match = clause.match object.word
      if match?
        return object.word

  # TODO: Merge 'objects' and 'object'?
  objects: (clause) ->
    matches = []
    for key, object of @map
      match = clause.match object.word
      if match?
        matches.push match

  property: (clause, object) ->
    for key, obj of @map
# if obj.word is object
      for property of obj.properties
        match = clause.match property
        if match?
          return property

  value: (clause) ->

# If value defined in dictionary -> return dictionary value
    verb = @verb clause
    if verb?
      if verb.value?
        return verb.value

    # Else -> match patterns
    pattern = new RegExp("(to )|(by )")
    match = clause.match pattern
    if match?
      value = clause.slice match.index
      value = value.replace match[0], ""
      value = value.split(" ")[0]
      return value
    # FIXME: FIX THIS HACK!
    pattern = /\d+ time(s)|( )/g
    match = pattern.exec clause
    if match?
      value = clause.slice match.index
      value = value.replace "times", ""
      if not isNaN parseInt value
        value = parseInt value
      return value

  conditional: (clause) ->
    for k,v of @dict.conditionals
      pattern = new RegExp k
      match = clause.match pattern
      if match?
        return type: v.type

  unit: (clause) ->
    for entry, definition of @dict.units
      match = clause.match definition.pattern
      if match?
        return entry

  reference: (clause) ->
    pattern = /"|'/g
    indices = []
    loop
      match = pattern.exec clause
      if match? then indices.push match.index else break
    if indices.length > 0
      start = indices[0] + 1
      end = indices[1]
      reference = clause[start...end]
    reference

module.exports = Finder