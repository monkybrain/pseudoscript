dict = require "./../src/dictionaries/dictionary"

class Preprocessor

  @numbers: dict.preprocessor.numbers

  # SINGLE LINE OPERATIONS #
  @trim: (line) ->
    line.trim()

  @replace: (line) ->
    for num, words of @numbers
      for word in words
        line = line.replace word, num
    line

  @lowercase: (line) ->
    line.toLowerCase()

  @comments: (line) ->
    index = line.indexOf "#"
    if index isnt -1 then line[...index] else line

  # MULTILINE OPERATIONS #
  @split: (file) ->
    file.split /(\n)|(\.)/g

  @filter: (lines) ->
    lines.filter (line) ->
      patterns = ['', undefined, null, "\.", "\n"]
      if line in patterns then false else true

  @process: (file) ->
    lines = @filter @split file
    lines = lines.map (line) =>
      line = @replace @trim @lowercase @comments line
    @filter lines



module.exports = Preprocessor
