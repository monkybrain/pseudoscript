dict = require "./../dictionaries/dictionary"
modules = require "./../modules/modules"
Find = require "./find"

class Preprocessor

  @numbers: dict.preprocessor.numbers

  ### SINGLE LINE OPERATIONS ###
  @trim: (line) ->
    line.trim()

  @replace: (line) ->

    for num, words of @numbers
      for word in words
        line = line.replace word, num
    line

  @lowercase: (line) ->
    # Conver to lowercase (excluding refs)
    refs = Find.references line
    line = line.toLowerCase()
    if refs?
      for ref in refs
        line = line.replace ref.toLowerCase(), ref
    return line

  @comments: (line) ->
    index = line.indexOf "#"
    if index isnt -1 then line[...index] else line

  ### MULTILINE OPERATIONS ###
  @split: (file) ->
    file.split /(\n)|(\.)/g

  @filter: (lines) ->
    lines.filter (line) ->
      patterns = ['', undefined, null, "\.", "\n"]
      if line in patterns then false else true

  ### PHRASES ###
  # FIXME: TO BE IMPLEMENTED!
  @phrases: (line) ->
    for module in modules
      if module.lexical.phrases?
        for phrase in module.lexical.phrases

          # Find ref
          pattern = new RegExp phrase.pattern.replace("<object>", "(\\w*\\s*)*\\'((\\w+)?(\\s+?\\w+?)*)'")
          if match?
            console.log match
            object = match[2]
            translation = "#{phrase.verb} '#{object}' #{phrase.property} #{phrase.value}"
            line = line.replace pattern, translation

          # Find object
          # TODO: IMPLEMENT THIS!

    return line


  @process: (file) ->
    lines = @filter @split file
    lines = lines.map (line) =>
      line = @replace @trim @lowercase @comments line
    @filter lines

    ###lines = lines.map (line) =>
      @phrases line###



module.exports = Preprocessor
