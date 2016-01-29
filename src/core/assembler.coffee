verbs = require "./../parts/verbs/verbs"
adverbs = require "./../parts/adverbs/adverbs"

class Assembler

  @indent:
    interval: 2
    level: 0
    inc: () ->
      this.level += 2
    dec: () ->
      this.level -= 2
    set: (level) ->
      this.level = level
    exec: (syntax) ->
      indent = ""
      for i in [0...this.level]
        indent += " "
      indent + syntax

  @parse: (segment) ->

    # Store indentation level
    level = @indent.level

    syntax = []
    closures = []

    # Handle segment phrase by phrase
    for phrase in segment

      # TODO: HARMONIZE VERB AND ADVERBS STRUCTURES
      if phrase.type is 'verb'
        for verb in verbs
          if phrase.verb is verb.lexical.base
            for line in verb.syntax phrase
              syntax.push @indent.exec line

            # syntax.push @indent.exec verb.syntax phrase

      if phrase.type is 'adverb'
        for adverb in adverbs
          if phrase.adverb in Object.keys(adverb.types)
            [open, close] = adverb.syntax phrase
            for line in open
              syntax.push @indent.exec line
            closures.push close

            # Increase indentation
            @indent.inc()

    # Handle closures (reverse order and dedent accordingly)
    for closure in closures.reverse()
      @indent.dec()
      syntax.push @indent.exec closure

    # Reset indentation level (NEEDED?)
    # @indent.set level

    syntax.join "\n"

  @wrap: (code) ->

    # Core modules
    imports = []
    imports.push "# Core modules"
    imports.push "Util = require '../src/core/util'\n"

    # TODO: Make dynamic
    modules = [
      {name: 'Light', path: '../src/modules/light'},
      {name: 'Room', path: '../src/modules/room'}
    ]

    # Add comment
    imports.push "# Custom modules"

    # Add line for each imported module
    for module in modules
      imports.push "#{module.name} = require '#{module.path}'"

    # Add new line to last import
    imports[imports.length - 1] = imports[imports.length - 1] + "\n"

    # Concat
    code = imports.concat code
    code


module.exports = Assembler