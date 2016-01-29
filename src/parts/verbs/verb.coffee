class Verb

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

module.exports = Verb