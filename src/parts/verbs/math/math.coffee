Verb = require "../verb"

class Math extends Verb

  @isExpression: (operand) ->
    pattern = /\d+?\s*((\*|\+|\-|\\)\s*\d+?)*/
    match = operand.match pattern
    return match?

  @getOperand: (text) ->
    pattern = /(\bby\b)\s+?(.*)/
    match = text.match pattern
    if match?
      operand = match[2]
      return operand

module.exports = Math