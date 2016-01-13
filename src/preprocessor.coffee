dict = require "./dictionaries/dictionary"

class Preprocessor

  @numbers: dict.preprocessor.numbers

  @process: (line) ->
    for num, words of @numbers
      for word in words
        line = line.replace word, num
    line

module.exports = Preprocessor
