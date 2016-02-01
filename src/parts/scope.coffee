modules = require "../modules/modules"

class Scope

  # Modules
  @modules: []
  @current: {}
  @type: null
  @subtype: null

  # Variables
  @variables = []

  @getByRef: (ref) =>
    for k, v of @modules
      if ref is v.ref
        return k

module.exports = Scope