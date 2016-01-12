class Module

  @members: []

  constructor: () ->
    # Set default values
    @properties = {}
    for key, value of @constructor.properties
      @properties[key] = value.default

  @add: (module, ref) ->
    Module.members.push module: module, ref: ref
    this.members.push ref

module.exports = Module
