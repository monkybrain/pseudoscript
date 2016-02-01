Math = require "./math"
Scope = require "../../../parts/scope"

class Multiply extends Math

  @lexical:
    base: 'multiply'
    synonyms: ['multiply']

  @test: (text) ->
    pattern = /(\bmultiply\b)\s+?(.*)\bby\b(.*)/
    match = text.match pattern
    operands = []
    if match
      operands.push match[2]
      split = @split match[0]
      for segment in split
        operands.push @getOperand segment
      operands = operands.map (operand) -> operand.trim()

      return type: 'verb', verb: 'multiply', operands: operands

  @syntax: (phrase) ->
    operands = phrase.operands.map (operand) =>
      if not @isExpression operand
        return "Globals['#{operand}']"
      else operand

    syntax = []
    syntax.push "# Multiplying"
    operands = operands.join ", "
    syntax.push ".then -> Util.math.multiply " + operands + "\n"
    syntax

module.exports = Multiply
