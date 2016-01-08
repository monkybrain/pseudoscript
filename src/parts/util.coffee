class Util

  @find:
    string: (text) ->
      pattern = /"|'/g
      indices = []
      loop
        match = pattern.exec text
        if match? then indices.push match.index else break
      if indices.length > 0
        start = indices[0] + 1
        end = indices[1]
        reference = text[start...end]
      reference

module.exports = Util