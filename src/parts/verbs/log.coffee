### VERB: LOG ###

modules = require "../../modules/modules"
Verb = require "../../parts/verbs/verb"
Scope = require "../../parts/scope"
Find = require "../../core/find"

class Log extends Verb

  @lexical:
    base: 'log'
    synonyms: ['log']

  @test: (text) ->
    # pattern = /\blog\b(\s+?(.*))*/
    pattern = /\blog\b(\s+?(.*))*/
    match = text.match pattern
    if match?
      result = false
      parameters = match[2]
      if parameters?
        parameters = @split parameters
        properties = parameters.filter (parameter) -> parameter.indexOf("'") is -1
        # TODO: Ugly handling below
        if properties?
          for property in properties
            if property is 'result'
              properties.splice properties.indexOf 'result', 1
              result = true
              break
          if properties.length is 0
            properties = undefined
        strings = Find.references parameters.join " "
      else
        result = true
      return type: 'verb', verb: 'log', properties: properties, strings: strings, result: result

  @syntax: (phrase, level) ->

    # TODO: Implement chain levels!
    syntax = []
    if level isnt 0
      syntax.push "# Log"
      syntax.push ".then (response) ->"
      indent = "  "
    else
      indent = ""

    if phrase.strings?
      strings = phrase.strings.map (string) -> "'#{string}'"
      string = strings.join ", "
      syntax.push indent + "# Log strings"
      syntax.push indent + "Util.log string for string in [#{strings}]"

    if phrase.properties?
      props = phrase.properties.map (property) -> "'#{property}'"
      props = props.join ", "
      syntax.push indent + "# Log properties"
      syntax.push indent + "Util.log \"\#{key}: \#{Globals[key]}\" for key in [#{props}]\n"

    if phrase.result
      syntax.push indent + "# Log response"
      syntax.push indent + "Util.log response"

    syntax

module.exports = Log

