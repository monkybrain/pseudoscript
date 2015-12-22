# Simple dictionary
module.exports =

  prepositions:
    to:
      patterns: ["to"]

  # Verbs
  verbs:
    create:
      patterns: ["let there be", "create", "add"]
      syntax: (scope, model, ref, indirect) ->

        # Construct object identifier
        object = model.self + "_" + model.count++

        # Process scope
        model.scope = object

        # Check if indirect object available, else implicit scope
        parent = if indirect? then indirect else scope

        # Construct syntax
        syntax = []
        syntax.push "#{object} = new #{model.Self}(#{ref})"
        syntax.push "#{parent}.add #{object}"
        syntax.join "\n"


  adverbs:
    scope:
      pattern: /in that/
      syntax: (object) ->
        "#{object.Self}.scope"

  ignore: ['another', 'a', 'an', 'yet', 'the']