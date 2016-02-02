verbs = require "./../parts/verbs/verbs"
adverbs = require "./../parts/adverbs/adverbs"

class Assembler

  @indent:
    interval: 2
    level: 0
    inc: () ->
      @level += 2
    dec: () ->
      @level -= 2
    set: (level) ->
      @level = level
    exec: (syntax) ->
      indent = ""
      for i in [0...@level]
        indent += " "
      indent + syntax

  @chain:
    level: 0
    inc: -> @level += 1
    reset: -> @level = 0
    close: false
    error:
      comment: "# Catch errors"
      syntax: ".catch (err) -> Util.error err\n"

  @parse: (segment) ->

    syntax = []
    closures = []

    previous = type: null, verb: null

    # Handle segment phrase by phrase
    for phrase, index in segment

      # TODO: HARMONIZE VERB AND ADVERBS STRUCTURES
      if phrase.type is 'verb'
        for verb in verbs
          if phrase.verb is verb.lexical.base
            for line in verb.syntax phrase, @chain.level
              syntax.push @indent.exec line

            # If 'add' -> continue, i.e. don't catch rejections
            if phrase.verb is 'add'
              continue

            # Increment promise chain level
            @chain.inc()

            # If last phrase -> implement error handling here
            if index is segment.length - 1
              syntax.push @indent.exec @chain.error.comment
              syntax.push @indent.exec @chain.error.syntax
              @chain.reset()
            # Else -> set error handling flag
            else @chain.close = true

      else if phrase.type is 'adverb'
        for adverb in adverbs

          # If error handling flag set -> add error handling
          if @chain.close
            syntax.push @indent.exec @chain.error.comment
            syntax.push @indent.exec @chain.error.syntax
            @chain.reset()
            @chain.close = false

          if phrase.adverb in Object.keys(adverb.types)
            [open, close] = adverb.syntax phrase, @chain.level
            for line in open
              syntax.push @indent.exec line

            # Add closure to array (but not yet to syntax)
            closures.push close

            # Increase indentation
            @indent.inc()

            # Reset promise chain level and add error handling
            @chain.reset()

    # Handle closures (reverse order and dedent accordingly)
    for closure in closures.reverse()
      @indent.dec()
      syntax.push @indent.exec closure

    syntax.join "\n"

  @wrap: (code) ->

    # Core modules
    imports = []
    imports.push "# Core modules"
    imports.push "Util = require '../src/core/util'"
    imports.push "Globals = require '../src/core/runtime/globals'\n"

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