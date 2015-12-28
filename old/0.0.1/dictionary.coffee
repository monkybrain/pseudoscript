# Simple dictionary
module.exports =

  types:
    questions:
      number:
        patterns: [/how many.*?/]
        syntax: (claas, members) ->
          "console.log question"

  prepositions:
    to:
      patterns: ["to"]

  # Verbs
  verbs:
    create:
      patterns: ["let there be", "create", "add"]
      syntax: (scope, model, ref, indirect) ->

        # Construct object identifier
        object = model.self + "s[" + model.count++ + "]"

        # Process scope
        model.scope = object

        # Check if indirect object available, else implicit scope
        parent = if indirect? then indirect else scope

        # Construct syntax
        syntax = []
        syntax.push "#{model.self}s.push new #{model.Self}(#{ref})"
        syntax.push "#{parent}.add #{object}"
        syntax.join "\n"

  adverbs:
    scope:
      pattern: /in that/
      syntax: (object) ->
        "#{object.Self}.scope"

  ignore: ['another', 'a', 'an', 'yet', 'the']